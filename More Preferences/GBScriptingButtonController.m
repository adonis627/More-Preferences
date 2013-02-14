//
//  GBScriptingButtonController.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/4/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBScriptingButtonController.h"

#import "GBUserDefaults.h"
#import "GBProgressSheetController.h"
#import "GBStandardLog.h"

static NSDictionary *infoDictionary;

@interface GBScriptingButtonController ()

@property (assign) IBOutlet NSButton *buttonRestoreLaunchpad;
@property (assign) IBOutlet NSButton *buttonUninstallMSOffice;
@property (assign) IBOutlet NSButton *buttonResetFinderOpenWithMenu;

- (IBAction)executeButtonPressed:(id)sender;
- (void)executeImpendingTasks:(id)sender;

@end


@implementation GBScriptingButtonController


+ (void)initialize
{
	infoDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"_Info" ofType:@"plist" inDirectory:@"Scripts"]];
}

#pragma mark _
#pragma mark GBScriptingButtonController Methods

- (IBAction)executeButtonPressed:(id)sender 
{
	BOOL hasPendingOperation = NO;
	
	for (NSButton *button in self.itemArray)
	{
		if (button.state == NSOnState)
		{
			hasPendingOperation = YES;
			break;
		}
	}
	
	if (hasPendingOperation)
	{
		NSInteger returnCode = NSRunCriticalAlertPanel(@"Are you sure you want to proceed?", @"Some tasks might take longer time than others. Don't turn off your computer during this time. You can, however, continue using your computer as usual.", @"OK", nil, @"Cancel");
		
		if (returnCode == NSAlertDefaultReturn)
			[self executeImpendingTasks:self];
	}
	else
		NSRunInformationalAlertPanel(@"No tasks selected", @"Select at least one task and then try again.", @"OK", nil, nil);
}

- (void)executeImpendingTasks:(id)sender
{
	NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
	GBProgressSheetController *progressController = [GBProgressSheetController sharedController];
	
	[progressController beginSheetModalForWindow:[NSApp mainWindow]];
	
	for (NSButton *aButton in self.itemArray)
	{
		if (aButton.state == NSOnState)
		{
			NSDictionary *scriptInfo = [infoDictionary objectForKey:aButton.identifier];
			NSURL *scriptURL = [[NSBundle mainBundle] URLForResource:[scriptInfo valueForKey:@"Script"] withExtension:@"scpt" subdirectory:@"Scripts"];
			NSDictionary *error = nil;
			
			[progressController setOperationDescription:[scriptInfo valueForKey:@"Description"]];
			
			NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:&error];
			
			if (error)
			{
				GBStandardLog(@"%@", error);
				NSRunAlertPanel(@"An error occured", @"More Preferences couldn't locate a script. Check the log for more information", @"OK", nil, nil);
			}
			
			else 
			{
				[script executeAndReturnError:&error];
				GBAssertLog(error, @"%@", error);
				
				[notiCenter postNotificationName:GBParameterDidSynchronizeToDiskNotification object:self userInfo:[NSDictionary dictionaryWithObject:[scriptInfo valueForKey:@"Associated Apps"] forKey:GBParameterDidSynchronizeToDiskNotificationAssociatedApps]];
			}
		}
	}
	
//	[progressController endSheet];
//	[notiCenter postNotificationName:GBApplicationShouldPresentInfoSheetNotification object:self userInfo:nil];
	[self performSelector:@selector(endProgressSheet) withObject:nil afterDelay:0.3];
}

- (void)endProgressSheet
{
	[[GBProgressSheetController sharedController] endSheet];
	[[NSNotificationCenter defaultCenter] postNotificationName:GBApplicationShouldPresentInfoSheetNotification object:self userInfo:nil];
}


#pragma mark _
#pragma mark GBButtonController Subclassed


- (void)loadParameters:(id)sender
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	for (NSButton *aButton in self.itemArray)
		[aButton setState:[userDefaults integerForKey:aButton.identifier]];
}

- (void)controllerShouldSyncParametersToDisk:(NSNotification *)notification
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	for (NSButton *aButton in self.itemArray)
		[userDefaults setInteger:aButton.state forKey:aButton.identifier];
}

- (NSArray *)itemArray
{
	if (!_itemArray)
	{
		_itemArray = [[NSArray alloc] initWithObjects:self.buttonRestoreLaunchpad, self.buttonUninstallMSOffice, self.buttonResetFinderOpenWithMenu, nil];
		GBDebugLog(@"%@ has %lu buttons\n", [self className], _itemArray.count);
	}

	return _itemArray;
}

@end
