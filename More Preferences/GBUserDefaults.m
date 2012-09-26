//
//  GBPreferenceWriter.m
//  Hidden Preferences
//
//  Created by 竞纬 戴 on 6/1/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBUserDefaults.h"

#import "GBGlobalDef.h"
#import "GBStandardLog.h"

static NSDictionary *infoDictionary;

@interface GBUserDefaults ()
@property (nonatomic, assign) NSDictionary *bundleInfo;
@end

@implementation GBUserDefaults

@synthesize bundleName = _bundleName;
@synthesize bundleInfo = _bundleInfo;

@synthesize bundleIdentifier = _bundleIdentifier;
@synthesize persistentDomain = _persistentDomain;


+ (void)initialize
{
	infoDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] 
												  pathForResource:@"Persistent ID" 
														   ofType:@"plist"]];
}

- (void)dealloc
{
	[_persistentDomain release];

	[super dealloc];
}


#pragma mark _
#pragma mark Public Methods

+ (id)userDefaultsWithBundleName:(NSString *)bundleName
{
	return [[[GBUserDefaults alloc] initWithBundleName:bundleName] autorelease];
}

- (id)initWithBundleName:(NSString *)bundleName
{
	if ((self = [self init])) 
		[self setBundleName:bundleName];
	return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
	[self.persistentDomain setValue:value forKey:key];
}

- (id)valueForKey:(NSString *)key
{
	return [self.persistentDomain valueForKey:key];
}

- (BOOL)synchronize
{
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:self.persistentDomain forName:self.bundleIdentifier];
	GBStandardLog(@"Synchronized with %@", self.bundleIdentifier);
	return YES;
}


#pragma mark _
#pragma mark Property Accessors

- (NSArray *)associatedApps
{
	return [_bundleInfo valueForKey:@"Associated Apps"];
}

- (void)setBundleName:(NSString *)bundleName
{
	if (![_bundleName isEqualToString:bundleName])
	{
		_bundleName = [bundleName retain];
		
		_bundleInfo = [infoDictionary valueForKey:bundleName];
		_bundleIdentifier = [_bundleInfo valueForKey:@"Bundle Identifier"];

		[_persistentDomain release];
		_persistentDomain = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:_bundleIdentifier] mutableCopy];
	}
}

@end
