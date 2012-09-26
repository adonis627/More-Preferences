//
//  GBButtonController.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/4/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBButtonController.h"

@implementation GBButtonController

@synthesize itemArray	= _itemArray;
@synthesize prefWriter	= _prefWriter;


#pragma mark _
#pragma mark GBButtonController Default

- (id)init
{
	if ((self = [super init]))
	{
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		
		[notificationCenter addObserver:self selector:@selector(controllerShouldLoadParameters:) name:GBButtonControllerShouldLoadParametersNotification object:nil];
		[notificationCenter addObserver:self selector:@selector(controllerShouldSyncParametersToDisk:) name:NSApplicationWillTerminateNotification object:nil];
	}
	return self;
}

- (void)dealloc
{
	[_itemArray release];
	[_prefWriter release];
	[super dealloc];
}

- (GBUserDefaults *)prefWriter
{
	if (!_prefWriter)
		_prefWriter = [[GBUserDefaults alloc] init];
	return _prefWriter;
}


#pragma mark _
#pragma mark GBButtonController Default (Subclassed)

- (void)controllerShouldLoadParameters:(NSNotification *)notification
{
	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadParameters:) object:self];
	[[thread autorelease] start];
}

- (void)loadParameters:(id)sender
{
	GBDebugLog(@"%s - %@\n", __PRETTY_FUNCTION__, sender);
}

- (void)controllerShouldSyncParametersToDisk:(NSNotification *)notification
{

}


@end
