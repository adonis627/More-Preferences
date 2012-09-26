//
//  GBThemingController.m
//  More Preferences
//
//  Created by Andrew A.A. on 8/7/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBThemingController.h"
#import "GBProgressSheetController.h"
#import "NSTask+PrivilegedTask.h"
#import "GBStandardLog.h"

#define kArtFileBinaryPath @"/System/Library/PrivateFrameworks/CoreUI.framework/Versions/A/Resources/ArtFile.bin"
#define kSArtFileBinaryPath @"/System/Library/PrivateFrameworks/CoreUI.framework/Versions/A/Resources/SArtFile.bin"

NSString *kApplicationSupportPath;
NSString *kInstallHelperPath;

@interface GBThemingController ()

@property (nonatomic, assign) IBOutlet NSWindow *recentBackupPanel;
@property (nonatomic, assign) IBOutlet NSArrayController *recentBackupArrayController;
@property (nonatomic, strong) NSMutableArray *recentBackupArray;

- (IBAction)backupCurrentTheme:(id)sender;		// backup to Application Support folder with date suffix
- (IBAction)restoreThemeFromBackup:(id)sender;	// opens sheet to choose backup to restore from

- (IBAction)compileTheme:(id)sender;	// opens sheet to choose folder
- (IBAction)installTheme:(id)sender;	// opens sheet to choose theme to install

- (IBAction)beginRestoreTheme:(id)sender;
- (IBAction)cancelRestoreTheme:(id)sender;

- (void)refreshBackupRecord;

@end

@implementation GBThemingController

@synthesize recentBackupPanel = _recentBackupPanel;
@synthesize recentBackupArray = _recentBackupArray;
@synthesize recentBackupArrayController = _recentBackupArrayController;

+ (void)initialize
{
	kApplicationSupportPath = [[NSString alloc] initWithFormat:@"%@", [@"~/Library/Application Support/More Preferences/CoreUI Backup/" stringByExpandingTildeInPath]];
	kInstallHelperPath = [[NSString alloc] initWithFormat:@"%@", [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"com.hnist.More-Preferences.installer"]];
}

//- (id)init
//{
//	if ((self = [super init]))
//	{
//	}
//	
//	return self;
//}

- (void)dealloc
{
	[super dealloc];
}

- (void)backupCurrentTheme:(id)sender
{	
	GBProgressSheetController *progressSheetControl = [GBProgressSheetController sharedController];
	
	[progressSheetControl setOperationDescription:@"Backing up current theme..."];
	[progressSheetControl beginSheetModalForWindow:[NSApp mainWindow]];
	
	NSError *error = nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *backupDirectoryPath = [kApplicationSupportPath stringByAppendingPathComponent:[[NSDate date] description]];
	
	[fileManager createDirectoryAtPath:backupDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
	GBAssertLog(error != nil, error.description);
	
	[fileManager copyItemAtPath:kArtFileBinaryPath toPath:[backupDirectoryPath stringByAppendingPathComponent:@"ArtFile.bin"] error:&error];
	GBAssertLog(error != nil, error.description);
	
	[fileManager copyItemAtPath:kSArtFileBinaryPath toPath:[backupDirectoryPath stringByAppendingPathComponent:@"SArtFile.bin"] error:&error];
	GBAssertLog(error != nil, error.description);

    NSUserNotification *notification = [[NSUserNotification alloc] init];

    [notification setHasActionButton:NO];
	[notification setTitle:@"Backup Successful"];
	[notification setSoundName:NSUserNotificationDefaultSoundName];
	[notification setInformativeText:@"A backup of the CoreUI components has been created."];

	[[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
	[notification release];

	[self refreshBackupRecord];
	
	[progressSheetControl endSheet];
}

- (void)restoreThemeFromBackup:(id)sender
{
	[NSApp beginSheet:self.recentBackupPanel modalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	[sheet orderOut:self];
}

- (void)beginRestoreTheme:(id)sender
{
	NSDictionary *backupInfo = self.recentBackupArrayController.selectedObjects.lastObject;
	NSInteger returnCode = NSRunAlertPanel(@"Are you sure you want to restore the backup?", @"After restoring, you'll need to log off your current account for interface changes to take effect", @"OK", nil, @"Cancel");

	if (returnCode == NSAlertDefaultReturn)
	{
		NSError *error = nil;
		NSString *backupPath = [backupInfo valueForKey:@"Path"];
		
		GBStandardLog(@"Copy %@ to %@", [backupPath stringByAppendingPathComponent:@"ArtFile.bin"], kArtFileBinaryPath);
		GBStandardLog(@"Copy %@ to %@", [backupPath stringByAppendingPathComponent:@"SArtFile.bin"], kSArtFileBinaryPath);
		
		NSTask *copyTask = [[NSTask alloc] init];
		
		[copyTask setLaunchPath:kInstallHelperPath];
		[copyTask setArguments:[NSArray arrayWithObjects:[backupPath stringByAppendingPathComponent:@"ArtFile.bin"], [@"~/Desktop/ArtFile.bin" stringByExpandingTildeInPath], nil]];
		
//		[copyTask launchWithRootPrivilege];
		NSLog(@"Fake launching...");
		
		if (error)
			NSLog(@"%@", error);
	}
	
	[NSApp endSheet:self.recentBackupPanel];
}

- (void)cancelRestoreTheme:(id)sender
{
	[NSApp endSheet:self.recentBackupPanel];
}


- (void)compileTheme:(id)sender
{
	
}

- (void)installTheme:(id)sender
{
	
}

- (NSWindow *)recentBackupPanel
{
	if (!_recentBackupPanel)
		[NSBundle loadNibNamed:@"Themes" owner:self];
	return _recentBackupPanel;
}

- (NSMutableArray *)recentBackupArray
{
	if (!_recentBackupArray)
	{
		_recentBackupArray = [[NSMutableArray alloc] init];
		[self refreshBackupRecord];
	}
	return _recentBackupArray;
}

- (void)refreshBackupRecord
{
	[self willChangeValueForKey:@"recentBackupArray"];
	
	[_recentBackupArray removeAllObjects];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	NSDate *date = nil;
	
	NSArray *backups = [fileManager contentsOfDirectoryAtPath:kApplicationSupportPath error:&error];
	
	for (NSString *folderName in backups)
	{
		date = [NSDate dateWithString:folderName];
		
		if (date)
			[_recentBackupArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:date, @"Date", [kApplicationSupportPath stringByAppendingPathComponent:folderName], @"Path", nil]];
		else
			NSLog(@"\"%@\" is not a valid directory.", folderName);
		
		date = nil;
	}
	
	[self didChangeValueForKey:@"recentBackupArray"];
}


@end
