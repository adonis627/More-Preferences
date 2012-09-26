//
//  GBProgressSheetController.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/3/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBProgressSheetController.h"

static GBProgressSheetController *sharedInstance;

@interface GBProgressSheetController ()

@property (assign) IBOutlet NSBox *progressViewBox;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;

@end


@implementation GBProgressSheetController

@synthesize progressIndicator = _progressIndicator;
@synthesize progressViewBox = _progressViewBox;
@synthesize operationDescription = _operationDescription;


#pragma mark _
#pragma mark GBProgressSheetController Shared Instance

+ (id)sharedController
{
	if (!sharedInstance)
		sharedInstance = [[GBProgressSheetController alloc] init];
	return sharedInstance;
}


#pragma mark _
#pragma mark NSWindowController Subclass

- (id)init
{
    self = [super initWithWindowNibName:@"Progress Sheet" owner:self];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
	self.operationDescription = @"Loading...";
}


#pragma mark _
#pragma mark GBProgressSheetController Methods

- (void)setOperationDescription:(NSString *)operationDescription
{
	[_operationDescription release];
	_operationDescription = [operationDescription retain];
	self.progressViewBox.title = _operationDescription;
}

- (void)beginSheetModalForWindow:(NSWindow *)window
{
	[NSApp beginSheet:self.window modalForWindow:window modalDelegate:self didEndSelector:nil contextInfo:nil];
	[self.progressIndicator startAnimation:self];
}

- (void)endSheet
{
	[NSApp endSheet:self.window];
	[self.window orderOut:self];
	[self.progressIndicator stopAnimation:self];
}

@end
