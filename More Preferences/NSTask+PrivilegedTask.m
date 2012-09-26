//
//  NSTask+PrivilegedTask.m
//  App Installer
//
//  Created by 竞纬 戴 on 5/22/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "NSTask+PrivilegedTask.h"
#import "GBStandardLog.h"

@implementation NSTask (PrivilegedTask)

- (void)launchWithRootPrivilege
{
	// Create authorization reference
	OSStatus status;
	AuthorizationRef authorizationRef;
	
	// AuthorizationCreate and pass NULL as the initial
	// AuthorizationRights set so that the AuthorizationRef gets created
	// successfully, and then later call AuthorizationCopyRights to
	// determine or extend the allowable rights.
	// http://developer.apple.com/qa/qa2001/qa1172.html
	status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
	if (status != errAuthorizationSuccess)
	{
		GBStandardLog(@"Error Creating Initial Authorization: %d", status);
		return;
	}
	
	// kAuthorizationRightExecute == "system.privilege.admin"
	AuthorizationItem right = {kAuthorizationRightExecute, 0, NULL, 0};
	AuthorizationRights rights = {1, &right};
	AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed |
	kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
	
	// Call AuthorizationCopyRights to determine or extend the allowable rights.
	status = AuthorizationCopyRights(authorizationRef, &rights, NULL, flags, NULL);
	if (status != errAuthorizationSuccess)
	{
		GBStandardLog(@"Copy Rights Unsuccessful: %d", status);
		return;
	}
	
	const char *tool = [self.launchPath cStringUsingEncoding:NSASCIIStringEncoding];
	size_t argCount = self.arguments.count;
	const char **args = malloc((argCount + 1) * sizeof(*args));
	
	for (int i = 0; i < argCount; ++i)
		args[i] = [[self.arguments objectAtIndex:i] cStringUsingEncoding:NSASCIIStringEncoding];
	args[argCount] = NULL;
	
	FILE *pipe = NULL;
	
	status = AuthorizationExecuteWithPrivileges(authorizationRef, tool, kAuthorizationFlagDefaults, (char *const *)args, &pipe);

	if (status != errAuthorizationSuccess)
	{
		GBStandardLog(@"Error: %d", status);
		return;
	}
	
	free(args);
	status = AuthorizationFree(authorizationRef, kAuthorizationFlagDestroyRights);
}

@end
