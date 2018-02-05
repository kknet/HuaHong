//
//  AppDelegate+Notification.h
//  HuaHong
//
//  Created by 华宏 on 2018/1/30.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (Notification)<UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UILocalNotification *localNotification;

- (void)setApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)setLocalNotification;

@end
