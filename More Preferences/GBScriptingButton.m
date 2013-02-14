//
//  GBScriptingButton.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/4/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBScriptingButton.h"

@implementation GBScriptingButton


- (void)dealloc
{
	[_bundleName release];
	[_scriptIdentifier release];
	[super dealloc];
}

@end
