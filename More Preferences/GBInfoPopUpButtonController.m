//
//  GBPopUpButtonController.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/3/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBInfoPopUpButtonController.h"
#import "GBInfoPopUpButton.h"
#import "GBInfoMenuItem.h"

@interface GBInfoPopUpButtonController ()

@property (assign) IBOutlet GBInfoPopUpButton *popUpDockAnimation;
@property (assign) IBOutlet GBInfoPopUpButton *popUpDockPosition;
@property (assign) IBOutlet GBInfoPopUpButton *popUpDockAlignment;
@property (assign) IBOutlet GBInfoPopUpButton *popUpScreenCaptureFormat;

- (IBAction)popUpButtonPressed:(id)sender;

@end

@implementation GBInfoPopUpButtonController

@synthesize popUpDockPosition;
@synthesize popUpDockAlignment;
@synthesize popUpDockAnimation;
@synthesize popUpScreenCaptureFormat;


#pragma mark _
#pragma mark GBInfoPopUpButtonController Methods

- (IBAction)popUpButtonPressed:(GBInfoPopUpButton *)sender
{
	GBUserDefaults *prefWriter = self.prefWriter;

	[prefWriter setBundleName:sender.bundleName];
	[prefWriter setValue:sender.selectedItemIdentifier forKey:sender.parameterKey];
	[prefWriter synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:GBParameterDidSynchronizeToDiskNotification object:self userInfo:[NSDictionary dictionaryWithObject:prefWriter.associatedApps forKey:GBParameterDidSynchronizeToDiskNotificationAssociatedApps]];
}


#pragma mark _
#pragma mark GBButtonController Subclass

- (void)loadParameters:(id)sender
{	
	for (GBInfoPopUpButton *aButton in self.itemArray)
	{
		[self.prefWriter setBundleName:aButton.bundleName];
		[aButton selectItemWithIdentifer:[self.prefWriter valueForKey:aButton.parameterKey]];
	}
}

- (NSArray *)itemArray
{
	if (!_itemArray)
	{
		NSMutableArray *itemArray = [[NSMutableArray alloc] initWithObjects:self.popUpDockAlignment, self.popUpDockAnimation, self.popUpDockPosition, self.popUpScreenCaptureFormat, nil];
		[itemArray sortUsingComparator:^NSComparisonResult(GBInfoPopUpButton *obj1, GBInfoPopUpButton *obj2) {
			return [obj1.bundleName compare:obj2.bundleName];
		}];
		_itemArray = itemArray;
		GBDebugLog(@"%@ has %lu buttons\n", [self className], _itemArray.count);
	}
	return _itemArray;
}

@end
