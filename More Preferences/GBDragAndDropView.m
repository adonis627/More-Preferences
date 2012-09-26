//
//  GBDragAndDropView.m
//  GBDragAndDropView
//
//  Created by 竞纬 戴 on 4/22/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBDragAndDropView.h"

GBNotificationKey GBNotificationDidReceiveInstallableFile = @"DidReceiveFiles";
GBNotificationKey GBNotificationReceivedInstallableFile = @"ReceivedFiles";

@interface GBDragAndDropView ()
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSMutableArray *receivedFiles;
@property (nonatomic) BOOL isHighlighted;

// use this method instead of manually update view content and then call setNeedsDisplay
- (void)updateDragAndDropViewStyle:(GBDragAndDropViewStyle)style;
@end


@implementation GBDragAndDropView

@synthesize image				= _image;
@synthesize isHighlighted		= _isHighlighted;

@synthesize background			= _background;
@synthesize backgroundMouseOver	= _backgroundMouseOver;

@synthesize receivedFiles		= _receivedFiles;
@synthesize supportedFileTypes	= _supportedFileTypes;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    }
    return self;
}

- (void)initilizeBackground:(NSImage *)background 
		mouseOverBackground:(NSImage *)backgroundMouseOver 
		 supportedFileTypes:(NSArray *)supportedFileTypes
{
	self.background = background;
	self.backgroundMouseOver = backgroundMouseOver;
	self.supportedFileTypes = supportedFileTypes;
}

- (void)drawRect:(NSRect)dirtyRect
{
	if (!self.image)
		self.image = self.background;
	
	[self.image drawInRect:self.frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	
	if (self.isHighlighted) {
		[[NSColor keyboardFocusIndicatorColor] set];
		[NSBezierPath setDefaultLineWidth:5.0];
		[NSBezierPath strokeRect:self.bounds];
	}
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *draggedFiles = [pboard propertyListForType:NSFilenamesPboardType];
	
	for (NSString *filePath in draggedFiles)
		for (NSString *extension in self.supportedFileTypes)
			if ([extension isEqualToString:[filePath pathExtension]]) {
				[self updateDragAndDropViewStyle:GBDragAndDropMouseOverView];
				return NSDragOperationCopy;
			}
	
	return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
	NSArray *draggedFiles = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
	
	[self.receivedFiles removeAllObjects];
	
	for (NSString *filePath in draggedFiles)
		for (NSString *extension in self.supportedFileTypes) {
			if ([extension isEqualToString:[filePath pathExtension]]) {
				[self.receivedFiles addObject:filePath];
				break;
			}
		}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:GBNotificationDidReceiveInstallableFile object:self userInfo:[NSDictionary dictionaryWithObject:self.receivedFiles forKey:GBNotificationReceivedInstallableFile]];
	
	return YES;
}

// update view to represent mouse over event
- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
	[self updateDragAndDropViewStyle:GBDragAndDropNormalView];
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
	[self updateDragAndDropViewStyle:GBDragAndDropNormalView];
}

- (void)updateDragAndDropViewStyle:(GBDragAndDropViewStyle)style
{
	if (style == GBDragAndDropMouseOverView) {
		self.image = self.backgroundMouseOver;
		self.isHighlighted = YES;
	}
	else {
		self.image = self.background;
		self.isHighlighted = NO;
	}
	[self setNeedsDisplay:YES];
}

- (NSMutableArray *)receivedFiles
{
	if (!_receivedFiles)
		_receivedFiles = [[NSMutableArray alloc] initWithCapacity:3];
	return _receivedFiles;
}

@end
