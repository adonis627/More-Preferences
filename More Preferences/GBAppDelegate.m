//
//  GBAppDelegate.m
//  Maximal
//
//  Created by 竞纬 戴 on 6/1/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBAppDelegate.h"

#import "GBGlobalDef.h"
#import "GBUserDefaults.h"
#import "GBProgressSheetController.h"
#import "GBStandardLog.h"

#import <ServiceManagement/ServiceManagement.h>
#import <Security/Authorization.h>

@interface GBAppDelegate ()

@property (assign) IBOutlet NSToolbar *toolbar;
@property (assign) IBOutlet NSWindow *moreInfoSheet;
@property (assign) IBOutlet NSProgressIndicator *spinningIndicator;

@property (assign) IBOutlet NSView *contentViewGeneral;
@property (assign) IBOutlet NSView *contentViewThemes;
@property (assign) IBOutlet NSView *contentViewUtilities;
@property (assign) IBOutlet NSView *contentViewPreferences;

@property (assign) IBOutlet NSToolbarItem *toolbarThemesItem;
@property (assign) IBOutlet NSToolbarItem *toolbarGeneralItem;
@property (assign) IBOutlet NSToolbarItem *toolbarUtilitiesItem;

@property (nonatomic, retain, readonly) NSView *blankView;
@property (nonatomic, retain, readonly) NSMutableSet *associatedApp;
@property (nonatomic, retain, readonly) NSArray *toolbarItemIdentifiers;
@property (nonatomic, assign, readonly) double mainWindowToolbarHeight;

- (IBAction)quitPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)showMoreInfoSheet:(id)sender;
- (IBAction)switchMainContentView:(id)sender;

- (void)operationDidEnd:(NSNotification *)notification;

@end

@implementation GBAppDelegate

@synthesize toolbar, mainWindow, moreInfoSheet, spinningIndicator;
@synthesize toolbarThemesItem, toolbarGeneralItem, toolbarUtilitiesItem;
@synthesize contentViewThemes, contentViewGeneral, contentViewUtilities, contentViewPreferences;

@synthesize blankView				= _blankView;
@synthesize associatedApp			= _associatedApp;
@synthesize toolbarItemIdentifiers	= _toolbarItemIdentifiers;
@synthesize mainWindowToolbarHeight = _mainWindowToolbarHeight;

- (void)dealloc
{
	[_blankView release];
	[_associatedApp release];
	[_toolbarItemIdentifiers release];
	
	[super dealloc];
}


#pragma mark _
#pragma mark Application Delegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{	
	GBStandardLogInit();
	GBStandardLogNewLine();
	GBStandardLog(@"More Preferences launched");

	//
	[[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

	[self switchMainContentView:nil];
	[self.mainWindow makeKeyAndOrderFront:self];
	
	
	// install helper

//	NSError *error = nil;
//	if (![self blessHelperWithLabel:@"com.hnist.PluginInstaller" error:&error]) {
//		NSLog(@"Something went wrong!");
//	} else {
//		NSLog(@"Job is available!");
//	}
	
	// load everything else

	[[GBProgressSheetController sharedController] beginSheetModalForWindow:self.mainWindow];

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter addObserver:self selector:@selector(operationDidEnd:) name:GBParameterDidSynchronizeToDiskNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(showMoreInfoSheet:) name:GBApplicationShouldPresentInfoSheetNotification object:nil];

	[notificationCenter postNotificationName:GBButtonControllerShouldLoadParametersNotification object:self userInfo:nil];

	[self performSelector:@selector(endProgressSheet) withObject:nil afterDelay:0.1];
}

- (BOOL)blessHelperWithLabel:(NSString *)label error:(NSError **)error;
{
	BOOL result = NO;
	
	AuthorizationItem authItem		= { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
	AuthorizationRights authRights	= { 1, &authItem };
	AuthorizationFlags flags		=	kAuthorizationFlagDefaults				|
	kAuthorizationFlagInteractionAllowed	|
	kAuthorizationFlagPreAuthorize			|
	kAuthorizationFlagExtendRights;
	
	AuthorizationRef authRef = NULL;
	
	OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, &authRef);
	if (status != errAuthorizationSuccess) {
		NSLog(@"Failed to create AuthorizationRef, return code %i", status);
	} else {
		/* This does all the work of verifying the helper tool against the application
		 * and vice-versa. Once verification has passed, the embedded launchd.plist
		 * is extracted and placed in /Library/LaunchDaemons and then loaded. The
		 * executable is placed in /Library/PrivilegedHelperTools.
		 */
		result = SMJobBless(kSMDomainSystemLaunchd, (CFStringRef)label, authRef, (CFErrorRef *)error);

		NSLog(@"%@", *error);

	}
	
	return result;
}

- (void)endProgressSheet
{
	[[GBProgressSheetController sharedController] endSheet];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
	return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
	if (!self.mainWindow.isVisible)
		[self.mainWindow makeKeyAndOrderFront:self];
	return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	if (self.mainWindow.isMiniaturized || self.mainWindow.isVisible)
		return NO;
	return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue:self.toolbar.selectedItemIdentifier forKey:GBSelectedToolbarItemIdentifier];
	
	GBStandardLog(@"More Preferences terminated");
	GBStandardLogNewLine();
	GBStandardLogDealloc();
}


#pragma mark
#pragma mark Toolbar Controller

//- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
//{ 
//	// needed for adding NSToolbarItem in code
//	NSDictionary *toolbarItems = nil;	// a NSToolbarItem with its identifier for key
//	return [toolbarItems objectForKey:itemIdentifier];
//}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return self.toolbarItemIdentifiers;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return self.toolbarItemIdentifiers;
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
	return self.toolbarItemIdentifiers;
}

- (NSArray *)toolbarItemIdentifiers
{
	if (!_toolbarItemIdentifiers)
		_toolbarItemIdentifiers = [[NSArray alloc] initWithObjects:@"General", @"Themes", @"Utilities", @"NSToolbarFlexibleSpaceItem", @"Preferences", nil];
	return _toolbarItemIdentifiers;
}

- (double)mainWindowToolbarHeight
{
	if (!_mainWindowToolbarHeight)
		_mainWindowToolbarHeight = self.mainWindow.frame.size.height - [self.mainWindow.contentView frame].size.height;
	return _mainWindowToolbarHeight;
}

- (NSView *)blankView
{
	if (!_blankView)
		_blankView = [[NSView alloc] init];
	return _blankView;
}

- (void)switchMainContentView:(id)sender
{
	NSString *itemIdentifier;
	
	if (!sender)
	{
		itemIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:GBSelectedToolbarItemIdentifier];
		[self.toolbar setSelectedItemIdentifier:itemIdentifier];
	}
	else
		itemIdentifier = ((NSToolbarItem *)sender).itemIdentifier;
	
	NSView *newContentView = nil;
	
	if ([itemIdentifier isEqualToString:@"General"])
		newContentView = self.contentViewGeneral;
	else if ([itemIdentifier isEqualToString:@"Themes"])
		newContentView = self.contentViewThemes;
	else if ([itemIdentifier isEqualToString:@"Utilities"])
		newContentView = self.contentViewUtilities;
	else if ([itemIdentifier isEqualToString:@"Preferences"])
		newContentView = self.contentViewPreferences;

	NSRect newMainWindowFrame = self.mainWindow.frame;
	
	newMainWindowFrame.size.height	=	newContentView.frame.size.height + self.mainWindowToolbarHeight; 
	newMainWindowFrame.size.width	=	newContentView.frame.size.width; 
	newMainWindowFrame.origin.y		+=	([self.mainWindow.contentView frame].size.height - newContentView.frame.size.height); 
	newMainWindowFrame.origin.x		+=	([self.mainWindow.contentView frame].size.width - newContentView.frame.size.width) / 2;

	[self.mainWindow setShowsResizeIndicator:YES];
	[self.mainWindow setContentView:self.blankView];
	[self.mainWindow setFrame:newMainWindowFrame display:YES animate:YES];
	[self.mainWindow setContentView:newContentView];
}


#pragma mark
#pragma mark Application Controller

+ (void)initialize
{
	@autoreleasepool 
	{

		NSMutableDictionary *defaultValues = [NSMutableDictionary dictionaryWithCapacity:5];
		
		[defaultValues setValue:@"General" forKey:GBSelectedToolbarItemIdentifier];
		[defaultValues setValue:@"~/Library/Logs/MorePreferences.log" forKey:GBLoggingURL];
		[defaultValues setValue:[NSNumber numberWithInt:GBLogToDefaultLocation] forKey:GBLoggingMode];

		[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *supportFolderPath = [@"~/Library/Application Support/More Preferences/" stringByExpandingTildeInPath];
		BOOL isDirectory = NO;
	
		if (![fileManager fileExistsAtPath:supportFolderPath isDirectory:&isDirectory])
			[fileManager createDirectoryAtPath:supportFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
}


- (void)operationDidEnd:(NSNotification *)notification
{
	[self willChangeValueForKey:@"associatedApp"];
	[self.associatedApp addObjectsFromArray:[notification.userInfo valueForKey:GBParameterDidSynchronizeToDiskNotificationAssociatedApps]];
	[self didChangeValueForKey:@"associatedApp"];
}

- (void)showMoreInfoSheet:(id)sender
{
	[NSApp	 beginSheet:self.moreInfoSheet
		modalForWindow:self.mainWindow
		 modalDelegate:self
		didEndSelector:@selector(moreInfoSheetDidEnd:returnCode:contextInfo:) 
		   contextInfo:nil];
}
	 
- (void)moreInfoSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	[sheet orderOut:self];
}

- (IBAction)quitPressed:(id)sender 
{
	[self.spinningIndicator startAnimation:self];
	
	for (NSString *bundleIdentifier in self.associatedApp)
	{
		@autoreleasepool
		{
			NSRunningApplication *anApp = [[NSRunningApplication runningApplicationsWithBundleIdentifier:bundleIdentifier] lastObject];
			
			if (anApp)
			{
				GBStandardLog(@"Terminating \"%@\"", anApp.localizedName);
				BOOL status = [anApp terminate];
				GBStandardLog(@"Termination status: %d", status);
			}
		}
	}
	
	[self willChangeValueForKey:@"associatedApp"];
	[self.associatedApp removeAllObjects];
	[self didChangeValueForKey:@"associatedApp"];
	
	[self.spinningIndicator stopAnimation:self];
	[NSApp endSheet:self.moreInfoSheet];
}

- (IBAction)cancelPressed:(id)sender 
{
	[NSApp endSheet:self.moreInfoSheet];
}

- (NSMutableSet *)associatedApp
{
	if (!_associatedApp)
		_associatedApp = [[NSMutableSet alloc] initWithCapacity:5];
	return _associatedApp;
}

- (IBAction)showReleaseNote:(NSMenuItem *)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[[NSBundle mainBundle] URLForResource:@"Release Note" withExtension:@"rtf"]];
}



@end
