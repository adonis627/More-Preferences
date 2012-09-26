//
//  GBInfoMenuItem.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/3/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBInfoMenuItem.h"

@implementation GBInfoMenuItem

@synthesize identifier = _identifier;

- (void)dealloc
{
	[_identifier release];

	[super dealloc];
}

@end
