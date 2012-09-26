//
//  GBInfoCheckButton.m
//  Hidden Preferences
//
//  Created by 竞纬 戴 on 6/1/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBInfoCheckButton.h"
#import "GBUserDefaults.h"

@implementation GBInfoCheckButton

@synthesize bundleName = _bundleName;
@synthesize parameterKey = _parameterKey;
@synthesize defaultKeyValue = _defaultKeyValue;

- (void)dealloc
{
	[_bundleName release];
	[_parameterKey release];
	[_defaultKeyValue release];
	
	[super dealloc];
}

@end
