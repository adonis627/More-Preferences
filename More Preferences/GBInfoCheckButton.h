//
//  GBInfoCheckButton.h
//  Hidden Preferences
//
//  Created by 竞纬 戴 on 6/1/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GBUserDefaults;

@interface GBInfoCheckButton : NSButton

@property (nonatomic, strong) NSString *bundleName;
@property (nonatomic, strong) NSString *parameterKey;
@property (nonatomic, strong) NSNumber *defaultKeyValue;

@end
