//
//  GBProgressSheetController.h
//  More Preferences
//
//  Created by 竞纬 戴 on 6/3/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GBProgressSheetController : NSWindowController

@property (nonatomic, strong) NSString *operationDescription;

+ (GBProgressSheetController *)sharedController;

- (void)beginSheetModalForWindow:(NSWindow *)window;
- (void)endSheet;

@end
