//
//  GBInfoPopUpButton.h
//  More Preferences
//
//  Created by 竞纬 戴 on 6/3/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GBInfoPopUpButton : NSPopUpButton

@property (nonatomic, strong) NSString *bundleName;
@property (nonatomic, strong) NSString *parameterKey;
@property (nonatomic, strong) NSString *defaultKeyValue;

@property (nonatomic, strong, readonly) NSString *selectedItemIdentifier;

/*
 *
 */
- (BOOL)selectItemWithIdentifer:(NSString *)identifier;

@end
