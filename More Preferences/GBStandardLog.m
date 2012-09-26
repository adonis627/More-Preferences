//
//  GBStandardLog.c
//  More Preferences
//
//  Created by 竞纬 戴 on 6/8/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//


#import "GBStandardLog.h"

NSFileHandle *_handle = nil;

void 
GBStandardLogInit ()
{
	[_handle dealloc];

//	GBLoggingModeConstant mode = [userDefaults integerForKey:GBLoggingMode];
	NSString *logPath = [[NSUserDefaults standardUserDefaults] stringForKey:GBLoggingURL].stringByStandardizingPath;
	
	if (!logPath)
		_handle = [NSFileHandle fileHandleWithNullDevice];
	else
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];

		if (![fileManager fileExistsAtPath:logPath])
			[fileManager createFileAtPath:logPath contents:nil attributes:nil];

		_handle = [NSFileHandle fileHandleForWritingAtPath:logPath];
	}
	
	[_handle seekToEndOfFile];
	[_handle retain];
}

void
GBStandardLogDealloc ()
{
	[_handle dealloc];
}
