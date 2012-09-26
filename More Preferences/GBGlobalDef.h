//
//  GBGlobalStrings.h
//  Hidden Preferences
//
//  Created by 竞纬 戴 on 6/1/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

typedef NSString *GBNotificationKey;
typedef NSString *GBUserPreferenceKey;

extern GBNotificationKey GBParameterDidSynchronizeToDiskNotification;
extern GBNotificationKey GBParameterDidSynchronizeToDiskNotificationAssociatedApps;

extern GBNotificationKey GBApplicationShouldPresentInfoSheetNotification;
extern GBNotificationKey GBButtonControllerShouldLoadParametersNotification;

extern GBUserPreferenceKey GBSelectedToolbarItemIdentifier;
extern GBUserPreferenceKey GBDeleteBundleAfterInstall;

enum {
	GBLogToNowhere = 1,
	GBLogToCustomLocation = 2,
	GBLogToDefaultLocation = 0
};
typedef NSInteger GBLoggingModeConstant;

extern GBUserPreferenceKey GBLoggingMode;
extern GBUserPreferenceKey GBLoggingURL;

