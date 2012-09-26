//
//  GBButtonController.h
//  More Preferences
//
//  Created by 竞纬 戴 on 6/4/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GBGlobalDef.h"
#import "GBUserDefaults.h"

@interface GBButtonController : NSObject {
	NSArray *_itemArray;
}

@property (nonatomic, retain) GBUserDefaults *prefWriter;
@property (nonatomic, retain) NSArray *itemArray;

- (void)controllerShouldLoadParameters:(NSNotification  *)notification;
- (void)loadParameters:(id)sender;

- (void)controllerShouldSyncParametersToDisk:(NSNotification *)notification;

@end

