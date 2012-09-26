//
//  NSTask+PrivilegedTask.h
//  App Installer
//
//  Created by 竞纬 戴 on 5/22/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTask (PrivilegedTask)

- (void)launchWithRootPrivilege;

@end
