//
//  GBStandard.h
//  More Preferences
//
//  Created by 竞纬 戴 on 6/7/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBGlobalDef.h"

extern 
NSFileHandle *_handle;

extern void 
GBStandardLogInit ();

extern void
GBStandardLogDealloc ();

#ifndef GBStandardLog
#define GBStandardLogFormatter(...) [NSString stringWithFormat:@"%@ - %@\n", [NSDate date], [NSString stringWithFormat:__VA_ARGS__]]
#define GBStandardLog(...) [_handle writeData:[GBStandardLogFormatter(__VA_ARGS__) dataUsingEncoding:NSUTF8StringEncoding]]
#define GBStandardLogNewLine() [_handle writeData:[NSData dataWithBytes:"\n" length:1]] 
#endif



