//
//  GBPreferenceWriter.h
//  Hidden Preferences
//
//  Created by 竞纬 戴 on 6/1/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBUserDefaults : NSObject

/*
 *	Update this value to access the bundle (app) defaults
 */
@property (nonatomic, retain) NSString *bundleName;

@property (nonatomic, assign, readonly) NSArray *associatedApps;
@property (nonatomic, assign, readonly) NSString *bundleIdentifier;
@property (nonatomic, strong, readonly) NSMutableDictionary *persistentDomain;

- (id)initWithBundleName:(NSString *)bundleName;
+ (id)userDefaultsWithBundleName:(NSString *)bundleName;

- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;

/*
 *	Update modified values using [NSUserDefaults setPersistentDomain:forName:
 */
- (BOOL)synchronize;

@end
