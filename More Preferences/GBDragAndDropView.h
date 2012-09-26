//
//  GBDragAndDropView.h
//  GBDragAndDropView
//
//  Created by 竞纬 戴 on 4/22/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Foundation/Foundation.h>

// used with updateDragAndDropViewStyle
typedef enum {
	GBDragAndDropNormalView = 1001,
	GBDragAndDropMouseOverView = 1002
} GBDragAndDropViewStyle;

typedef NSString *GBNotificationKey;

extern GBNotificationKey GBNotificationDidReceiveInstallableFile;
extern GBNotificationKey GBNotificationReceivedInstallableFile;

// interface
@interface GBDragAndDropView : NSImageView <NSDraggingDestination>

@property (nonatomic, strong) NSImage *background;
@property (nonatomic, strong) NSImage *backgroundMouseOver;

@property (nonatomic, strong) NSArray *supportedFileTypes;

// use this method to initilize the GBDragAndDropView instance in your controller
- (void)initilizeBackground:(NSImage *)background 
		mouseOverBackground:(NSImage *)backgroundMouseOver 
		 supportedFileTypes:(NSArray *)supportedFileTypes;

@end
