//
//  GBThemeDocument.m
//  More Preferences
//
//  Created by Andrew A.A. on 8/13/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBThemeDocument.h"
#import "GBGlobalDef.h"

NSString *themesFolder;
NSFileManager *fileManager;

@interface GBThemeDocument ()
@property (nonatomic, assign) IBOutlet NSTextField *detailMessage;
@property (nonatomic, retain) NSURL *documentURL;
@property (nonatomic, retain) NSDictionary *infoDict;
@property (nonatomic, retain) NSString *themeName;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)installPressed:(id)sender;
@end

@implementation GBThemeDocument

@synthesize detailMessage;

@synthesize infoDict = _infoDict;
@synthesize documentURL = _documentURL;
@synthesize themeName = _themeName;

+ (void)initialize
{
	fileManager = [NSFileManager defaultManager];
	themesFolder = [[NSString alloc] initWithFormat:@"%@", @"~/Library/Application Support/More Preferences/Themes/".stringByExpandingTildeInPath];
	
	if (![fileManager fileExistsAtPath:themesFolder])
		[fileManager createDirectoryAtPath:themesFolder withIntermediateDirectories:YES attributes:nil error:nil];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)dealloc
{
	[_infoDict release];
	[detailMessage.stringValue release];
	[super dealloc];
}

- (NSString *)windowNibName
{
    return @"GBThemeDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
	
	_themeName = [_infoDict valueForKey:@"Plugin Name"];

	detailMessage.stringValue = [[NSString alloc] initWithFormat:@"This will install the bundle \"%@\" for the current user.", _themeName];
}

- (void)cancelPressed:(id)sender
{
	[self close];
}

- (void)installPressed:(id)sender
{
	BOOL deleteOriginal = [[NSUserDefaults standardUserDefaults] boolForKey:GBDeleteBundleAfterInstall];
	NSString *destinPath = [themesFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.apptheme", _themeName]];
	
	if ([fileManager fileExistsAtPath:destinPath])
		[fileManager removeItemAtPath:destinPath error:nil];
		
	if (deleteOriginal)
		[fileManager moveItemAtPath:_documentURL.path toPath:destinPath error:nil];
	else
		[fileManager copyItemAtPath:_documentURL.path toPath:destinPath error:nil];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    
    [notification setHasActionButton:NO];
	[notification setTitle:@"Plugin Installed"];
	[notification setSoundName:NSUserNotificationDefaultSoundName];
	[notification setInformativeText:@"A 3rd party theme plugin has been installed."];

	[[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
	[notification release];
	
	[self close];
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
	_documentURL = [url retain];
	_infoDict = [[NSDictionary alloc] initWithContentsOfURL:[url URLByAppendingPathComponent:@"Info.plist"]];
	
	return YES;
}

@end
