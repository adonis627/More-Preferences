//
//  GBInfoPopUpButton.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/3/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBInfoPopUpButton.h"
#import "GBInfoMenuItem.h"

@implementation GBInfoPopUpButton

@synthesize bundleName	 = _bundleName;
@synthesize parameterKey = _parameterKey;
@synthesize defaultKeyValue	 = _defaultKeyValue;
@synthesize selectedItemIdentifier = _selectedItemIdentifier;

- (void)dealloc
{
	[_parameterKey release];
	[_bundleName release];
	[_defaultKeyValue release];
	[super dealloc];
}

- (BOOL)selectItemWithIdentifer:(NSString *)identifier
{	
	if (!identifier)
	{
		return [self selectItemWithIdentifer:self.defaultKeyValue];
	}
		
	for (GBInfoMenuItem *menuItem in self.itemArray)
	{
		if ([menuItem.identifier isEqualToString:identifier])
		{
			[self selectItem:menuItem];
			return YES;
		}
	}
	return NO;
}

- (NSString *)selectedItemIdentifier
{
	return [(GBInfoMenuItem *)self.selectedItem identifier];
}

@end
