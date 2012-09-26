//
//  GBPathPopUpButton.m
//  More Preferences
//
//  Created by 竞纬 戴 on 6/11/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBPathPopUpButtonCell.h"

@interface GBPathPopUpButtonCell ()

@property (nonatomic, assign) NSSize fileIconSize;
@property (nonatomic, assign) BOOL isRepresentingURL;
@property (nonatomic, assign) NSMenuItem *lastSelectedItem;
@property (nonatomic, retain) NSMenuItem *separatorMenuItem;

@end

@implementation GBPathPopUpButtonCell

@synthesize showFileIcon		= _showFileIcon;
@synthesize fileIconSize		= _fileIconSize;
@synthesize lastSelectedItem	= _lastSelectedItem;
@synthesize isRepresentingURL	= _isRepresentingURL;

@synthesize delegate			= _delegate;
@synthesize openPanel			= _openPanel;
@synthesize docWindow			= _docWindow;
@synthesize separatorMenuItem	= _separatorMenuItem;

- (void)dealloc
{
	[_delegate release];
	[_docWindow release];
	[_openPanel release];
	[_separatorMenuItem release];
	
	[super dealloc];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [super initWithCoder:coder])) 
	{
		float fontSize = self.font.ascender - self.font.descender;
		_fileIconSize = NSMakeSize(fontSize, fontSize);

		[self setShowFileIcon:YES];
		[self setTarget:self];
		[self setAction:@selector(selectedItemDidChange:)];		
    }
    return self;
}

- (void)selectedItemDidChange:(id)sender
{	
	if ([self.selectedItem isEqualTo:self.lastSelectedItem])
		return;
	
	if ([self.selectedItem isEqualTo:self.lastItem])		/* last item */
	{		
		[self.openPanel beginSheetModalForWindow:self.docWindow completionHandler:^(NSInteger result) {
			if (result == NSFileHandlingPanelOKButton)
			{
				self.representedObject = self.openPanel.URL;
				[self.delegate pathPopUpButtonCellDidUpdate:self representedFileURL:self.representedObject];
			}
			else
				[super selectItem:self.lastSelectedItem];
		}];
	}
	
	else
	{
		self.representedObject = nil;
		self.lastSelectedItem = self.selectedItem;
		
		[self.delegate pathPopUpButtonCellDidUpdate:self representedFileURL:nil];
	}
}

- (void)setRepresentedObject:(NSURL *)representedObject
{
	@autoreleasepool {

		if (!representedObject)
		{
			if (_isRepresentingURL)
			{
				[super removeItemAtIndex:0];
				[super removeItemAtIndex:0];
				_isRepresentingURL = NO;
			}
			return;
		}
		
		if (_isRepresentingURL)
		{
			[super selectItemAtIndex:0];
			[super.selectedItem setTitle:representedObject.lastPathComponent];
		}
		else
		{			
			[super.menu insertItem:self.separatorMenuItem atIndex:0];
			[super.menu insertItemWithTitle:representedObject.lastPathComponent action:nil keyEquivalent:@"" atIndex:0];

			[super selectItemAtIndex:0];
			_isRepresentingURL = YES;
			_lastSelectedItem = self.selectedItem;
		}

		if (_showFileIcon)
		{
			NSImage *fileIcon = [[NSWorkspace sharedWorkspace] iconForFile:representedObject.path];
			
			[fileIcon setSize:_fileIconSize];
			[self.selectedItem setImage:fileIcon];
		}
		
		[super setRepresentedObject:representedObject];
			/* had to be the last call */
	}
}

- (void)selectItemWithTitle:(NSString *)title
{
	[super selectItemWithTitle:title];
	_lastSelectedItem = self.selectedItem;
}

- (NSMenuItem *)separatorMenuItem
{
	if (!_separatorMenuItem)
		_separatorMenuItem = [[NSMenuItem separatorItem] retain];
	return _separatorMenuItem;
}

@end




