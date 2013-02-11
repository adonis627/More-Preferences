//
//  GBParameterController.m
//  Hidden Preferences
//
//  Created by 竞纬 戴 on 6/1/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBInfoCheckButtonController.h"
#import "GBInfoCheckButton.h"


@interface GBInfoCheckButtonController ()

@property (assign) IBOutlet NSButton *moreInfoButton;
@property (assign) IBOutlet NSTabView *mainTabView;

@property (assign) IBOutlet GBInfoCheckButton *turnOffDashboard;
@property (assign) IBOutlet GBInfoCheckButton *turnOffSafariPDFSupport;
@property (assign) IBOutlet GBInfoCheckButton *turnOffDockSizeMutability;
@property (assign) IBOutlet GBInfoCheckButton *turnOffAutomaticTermination;
@property (assign) IBOutlet GBInfoCheckButton *turnOffGoogleAutomaticUpdate;
@property (assign) IBOutlet GBInfoCheckButton *turnOffDockContentMutability;
@property (assign) IBOutlet GBInfoCheckButton *turnOffiTunesElasticScrolling;

@property (assign) IBOutlet GBInfoCheckButton *turnOnDesktop;
@property (assign) IBOutlet GBInfoCheckButton *turnOnShowHiddenFiles;
@property (assign) IBOutlet GBInfoCheckButton *turnOnWindowOpenAnimation;
@property (assign) IBOutlet GBInfoCheckButton *turnOniTunesHalfStarRating;
@property (assign) IBOutlet GBInfoCheckButton *turnOniTunesDockNotification;
@property (assign) IBOutlet GBInfoCheckButton *turnOnSafariSingleWindowMode;
@property (assign) IBOutlet GBInfoCheckButton *turnOnQuickLookTextSelection;
@property (assign) IBOutlet GBInfoCheckButton *turnOniTunesDockNotificationIcon;
@property (assign) IBOutlet GBInfoCheckButton *turnOnShowWarningBeforeChangingExtension;
@property (assign) IBOutlet GBInfoCheckButton *turnOnAutoPlayMoviesInQuickTime;
@property (assign) IBOutlet GBInfoCheckButton *turnOnShowPosixPathInWindowTitle;
@property (assign) IBOutlet GBInfoCheckButton *turnOnXRayFolderQuickLook;
@property (assign) IBOutlet GBInfoCheckButton *turnOnSaveToiCloudByDefault;
@property (assign) IBOutlet GBInfoCheckButton *turnOnSaveDialogOpenInExpandedMode;


- (IBAction)checkButtonStateDidChange:(GBInfoCheckButton *)sender;

@end

@implementation GBInfoCheckButtonController

@synthesize mainTabView;
@synthesize moreInfoButton;

@synthesize turnOffDashboard, turnOnShowHiddenFiles, turnOffSafariPDFSupport, turnOnWindowOpenAnimation, turnOnXRayFolderQuickLook, turnOffDockSizeMutability, turnOniTunesHalfStarRating, turnOffAutomaticTermination, turnOnSafariSingleWindowMode, turnOnQuickLookTextSelection, turnOniTunesDockNotification, turnOffGoogleAutomaticUpdate, turnOffDockContentMutability, turnOnAutoPlayMoviesInQuickTime, turnOnShowPosixPathInWindowTitle, turnOniTunesDockNotificationIcon, turnOnShowWarningBeforeChangingExtension, turnOnDesktop, turnOffiTunesElasticScrolling;

#pragma mark _
#pragma mark GBInfoCheckButtonController Methods

+ (void)initialize
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *destination = @"/Users/andrew/Library/Preferences/.GlobalPreferences.plist";
	NSString *newFilePath = @"/Users/andrew/Library/Preferences/com.apple.GlobalPreferences.plist";
	
	if (![fileManager fileExistsAtPath:newFilePath])
	{
		NSError *error = nil;
		[fileManager createSymbolicLinkAtPath:newFilePath withDestinationPath:destination error:&error];
		assert(error == nil);
	}
	[pool drain];
}

- (IBAction)checkButtonStateDidChange:(GBInfoCheckButton *)sender 
{
	[self.prefWriter setBundleName:sender.bundleName];
	
	[self.prefWriter setValue:[NSNumber numberWithBool:sender.state] forKey:sender.parameterKey];
	[self.prefWriter synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:GBParameterDidSynchronizeToDiskNotification object:self userInfo:[NSDictionary dictionaryWithObject:self.prefWriter.associatedApps forKey:GBParameterDidSynchronizeToDiskNotificationAssociatedApps]];
}


#pragma mark _
#pragma mark GBButtonController Subclass

- (void)loadParameters:(id)sender
{
	[self.mainTabView selectFirstTabViewItem:self];

	GBUserDefaults *prefWriter = self.prefWriter;
	
	for (GBInfoCheckButton *aButton in self.itemArray)
	{
		[prefWriter setBundleName:aButton.bundleName];
		NSNumber *state = [prefWriter valueForKey:aButton.parameterKey];

		if (!state)
			state = aButton.defaultKeyValue;
		[aButton setState:[state integerValue]];
	}
}

- (NSArray *)itemArray
{
	if (!_itemArray)
	{
		NSMutableArray *itemArray = [[NSMutableArray alloc] initWithObjects:self.turnOffAutomaticTermination, self.turnOffDashboard, self.turnOffDockContentMutability, self.turnOffDockSizeMutability, /* self.turnOffGoogleAutomaticUpdate, */ self.turnOffSafariPDFSupport, self.turnOnAutoPlayMoviesInQuickTime, self.turnOniTunesDockNotification, self.turnOniTunesDockNotificationIcon, self.turnOniTunesHalfStarRating, self.turnOnQuickLookTextSelection, self.turnOnSafariSingleWindowMode, self.turnOnShowHiddenFiles, self.turnOnShowPosixPathInWindowTitle, self.turnOnShowWarningBeforeChangingExtension, self.turnOnWindowOpenAnimation, self.turnOnXRayFolderQuickLook, self.turnOnDesktop, self.turnOffiTunesElasticScrolling, self.turnOnSaveDialogOpenInExpandedMode, self.turnOnSaveToiCloudByDefault, nil];
		[itemArray sortUsingComparator:^NSComparisonResult(GBInfoCheckButton *obj1, GBInfoCheckButton *obj2) {
			return [obj1.bundleName compare:obj2.bundleName];
		}];
		_itemArray = itemArray;
		GBDebugLog(@"%@ has %lu buttons\n", [self className], _itemArray.count);		
	}
	return _itemArray;
}

@end
