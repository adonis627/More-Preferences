//
//  GBScriptingButton.h
//  More Preferences
//
//  Created by 竞纬 戴 on 6/4/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GBScriptingButton : NSButton

@property (nonatomic, strong) NSString *bundleName;
@property (nonatomic, strong) NSString *scriptIdentifier;

@end
