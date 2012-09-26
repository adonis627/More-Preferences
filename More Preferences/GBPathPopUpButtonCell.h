//
//  GBPathPopUpButton.h
//  More Preferences
//
//  Created by 竞纬 戴 on 6/11/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GBPathPopUpButtonCell;
@protocol GBPathPopUpButtonCellDelegate;

@interface GBPathPopUpButtonCell : NSPopUpButtonCell

@property (nonatomic, retain) NSOpenPanel *openPanel;
@property (nonatomic, retain) NSWindow *docWindow;

@property (nonatomic, assign) BOOL showFileIcon;
@property (nonatomic, retain) IBOutlet id<GBPathPopUpButtonCellDelegate> delegate;

@end

@protocol GBPathPopUpButtonCellDelegate <NSObject>

@optional
@property (nonatomic, retain) IBOutlet GBPathPopUpButtonCell *pathPopUpButtonCell;

@required
- (void)pathPopUpButtonCellDidUpdate:(GBPathPopUpButtonCell *)pathPopUpButtonCell representedFileURL:(NSURL *)fileURL;

@end

