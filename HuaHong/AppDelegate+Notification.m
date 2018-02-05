//
//  AppDelegate+Notification.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/30.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "AppDelegate+Notification.h"

@implementation AppDelegate (Notification)

-(void)setApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //请求通知权限, 本地和远程共用
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 12.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"获取通知权限成功!");
            }
        }];
    }else
    {
        // iOS8以后 本地通知必须注册(获取权限)
        
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }
    
    // 注册远程通知
    [[UIApplication sharedApplication]registerForRemoteNotifications];
    
    //程序刚启动获取通知
//    UILocalNotification *localNoti = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];

}

- (void)setLocalNotification {
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 12.0) {
        
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"iOS10通知";
        content.subtitle = @"新通知学习笔记";
        content.body = @"这是iOS10以后的新通知，";
        content.badge = @1;
        UNNotificationSound *sound = [UNNotificationSound soundNamed:UILocalNotificationDefaultSoundName];
        content.sound = sound;
        
        //第三步：通知触发机制。（重复提醒，时间间隔要大于60s）
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        
        //第四步：创建UNNotificationRequest通知请求对象
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"local" content:content trigger:trigger];
        
        //第五步：将通知加到通知中心
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error:%@",error);
            
        }];
        
        
    }else
    {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:3];
        localNotification.alertBody = @"Background Fetch启动";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber += 1;
        //        self.localNotification.repeatInterval = NSCalendarUnitMinute;
        localNotification.region = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(self.latitude, self.longitude) radius:100 identifier:@"localNoti"];
        
        localNotification.repeatCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
        
        //没效果
        localNotification.alertAction = @"滑动查看";
        localNotification.hasAction = YES;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        
    }
    
    
    
}

#pragma mark - Local Notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"LocalNotification:%@",notification);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        return;
    }
}

-(void)cabcelLocalNotification
{
    //删除通知
    NSArray *arr = [[UIApplication sharedApplication]scheduledLocalNotifications];

    for (UILocalNotification *local in arr) {
        if (local.userInfo) {
            [[UIApplication sharedApplication]cancelLocalNotification:local];
        }
    }


    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}

#pragma mark - 远程通知代理方法
//d1ece78d 2de839f7 eb7cc936 69b493ee 3c820c1a c1bf0f2c a67e0b52 74ddbd16
//6a2cee08 e00bc63b 70231cb0 66cc3026 906e5226 47ed6884 785d0971 55581c2e
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    NSLog(@"deviceToken:%@",deviceToken);
}

#pragma mark iOS推送通知的处理方法
/**
 如果你需要接收推送通知. 那么需要实现3个方法
 1. willPresentNotification:withCompletionHandler   用于前台运行
 2. didReceiveNotificationResponse:withCompletionHandler  用于后台及程序退出
 3. didReceiveRemoteNotification:fetchCompletionHandler: 用于静默推送
 
 /**
 iOS10以后 前台运行 会调用的方法，会有横幅
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    //前台运行推送 显示红色Label
    [self showLabelWithUserInfo:userInfo color:[UIColor redColor]];
    
    //可以设置当收到通知后, 有哪些效果呈现(声音/提醒/数字角标)
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}


/**
 iOS10以后，后台运行及程序退出 会调用的方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    //后台及退出推送 显示绿色Label
    [self showLabelWithUserInfo:userInfo color:[UIColor greenColor]];
    
    completionHandler();
}




/**
 iOS10中, 此方法主要处理静默推送 --> iOS7以后出现, 不会出现提醒及声音
 1. 推送的payload中不能包含alert及sound字段
 2. 需要添加content-available字段, 并设置值为1
 例如: {"aps":{"content-available":"1"},"PageKey":"2"}
 */

//如果是以前的旧框架, 此方法 前台/后台/退出/静默推送都可以处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //静默推送 显示蓝色Label
    [self showLabelWithUserInfo:userInfo color:[UIColor blueColor]];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

//将通知的值显示在主界面上
- (void)showLabelWithUserInfo:(NSDictionary *)userInfo color:(UIColor *)color
{
    UILabel *label = [UILabel new];
    label.backgroundColor = color;
    label.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 300);
    label.text = userInfo.description;
    label.numberOfLines = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:label];
}
@end