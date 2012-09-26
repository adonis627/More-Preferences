//
//  GBScriptingButton.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/4/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBScriptingButton.h"

@implementation GBScriptingButton

@synthesize bundleName		 = _bundleName;
@synthesize scriptIdentifier = _scriptIdentifier;

- (void)dealloc
{
	[_bundleName release];
	[_scriptIdentifier release];
	[super dealloc];
}

@end
