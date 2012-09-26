//
//  GBAppPreferenceController.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/4/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBAppPreferenceController.h"

#import "GBGlobalDef.h"
#import "GBStandardLog.h"

@interface GBAppPreferenceController ()

@property (nonatomic, strong) NSOpenPanel *openPanel;
@property (nonatomic, assign) IBOutlet NSButton *deleteOriginalBundleAfterInstall;

- (IBAction)stateChanged:(id)sender;

@end

@implementation GBAppPreferenceController

@synthesize openPanel = _openPanel;
@synthesize pathPopUpButtonCell = _pathPopUpButtonCell;
@synthesize deleteOriginalBundleAfterInstall = _deleteOriginalBundleAfterInstall;

- (id)init
{
	if ((self = [super init]))
	{
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadParameters:) name:NSApplicationDidFinishLaunchingNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
	}
	return self;
}

- (void)dealloc
{
	[_openPanel release];
	[_pathPopUpButtonCell release];
	
	[super dealloc];
}

- (void)loadParameters:(NSNotification *)notification
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[self.deleteOriginalBundleAfterInstall setState:[userDefaults integerForKey:GBDeleteBundleAfterInstall]];

	[self.pathPopUpButtonCell setOpenPanel:self.openPanel];
	[self.pathPopUpButtonCell setDocWindow:[NSApp mainWindow]];

	GBLoggingModeConstant loggingMode = [userDefaults integerForKey:GBLoggingMode];
	
//	GBDebugLog(@"Logging mode: %ld", loggingMode);

	if (loggingMode == GBLogToNowhere)
		[self.pathPopUpButtonCell selectItemWithTitle:@"Don't log activity"];
	else if (loggingMode == GBLogToDefaultLocation)
		[self.pathPopUpButtonCell selectItemWithTitle:@"~/Library/Logs"];
	else
		[self.pathPopUpButtonCell setRepresentedObject:[userDefaults URLForKey:GBLoggingURL].URLByDeletingLastPathComponent];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{

}

- (void)pathPopUpButtonCellDidUpdate:(GBPathPopUpButtonCell *)pathPopUpButtonCell representedFileURL:(NSURL *)fileURL
{
	@autoreleasepool 
	{
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSString *selectedItemTitle = pathPopUpButtonCell.selectedItem.title;
		NSString *filePath = @"";

		if ([selectedItemTitle isEqualToString:@"~/Library/Logs"])
		{
			filePath = [NSString stringWithFormat:@"~/Library/Logs/MorePreferences.log"];
			
			[userDefaults setValue:filePath forKey:GBLoggingURL];
			[userDefaults setInteger:GBLogToDefaultLocation forKey:GBLoggingMode];
		}
		
		else if ([selectedItemTitle isEqualToString:@"Don't log activity"])
		{
			[userDefaults setValue:@"" forKey:GBLoggingURL];
			[userDefaults setInteger:GBLogToNowhere forKey:GBLoggingMode];
		}

		else
		{
			filePath = [fileURL URLByAppendingPathComponent:@"MorePreferences.log"].path;
			[userDefaults setValue:filePath forKey:GBLoggingURL];
			[userDefaults setInteger:GBLogToCustomLocation forKey:GBLoggingMode];
		}
		
		GBStandardLog(@"Updated logging preference");
	}
}

- (void)stateChanged:(NSButton *)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:sender.state forKey:[sender valueForKey:@"parameterKey"]];
}

- (NSOpenPanel *)openPanel
{
	if (!_openPanel)
	{
		_openPanel = [[NSOpenPanel alloc] init];
		[_openPanel setCanChooseFiles:NO];
		[_openPanel setCanChooseDirectories:YES];
		[_openPanel setCanCreateDirectories:YES];
		[_openPanel setDirectoryURL:[[NSUserDefaults standardUserDefaults] URLForKey:@"NSNavLastRootDirectory"]];
	}
	return _openPanel;
}

@end
