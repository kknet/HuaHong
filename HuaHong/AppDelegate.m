//
//  AppDelegate.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "LocationManager.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()
@property (strong, nonatomic) UILocalNotification *localNotification;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [self.window makeKeyAndVisible];

    TabBarViewController *tabBarVC = [[TabBarViewController alloc]init];
    self.window.rootViewController = tabBarVC;
    
    [LocationManager sharedLocationManager];
    
    [self shortcutItem];
    
    //长亮
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];

    //BackgroundFetch
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    //本地通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //请求获取通知权限（角标，声音，弹框）
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //获取用户是否同意开启通知
                NSLog(@"request authorization successed!");
            }
        }];
        
    }else
    {
        // iOS8以后 本地通知必须注册(获取权限)
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        
        [application registerUserNotificationSettings:settings];
    }
    
    
    [self baiduMap];
    
    return YES;
}

-(void)baiduMap
{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiDuMapKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }  
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"HuaHong"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    NSLog(@"name:%@\ntype:%@", shortcutItem.localizedTitle, shortcutItem.type);
    
    if ([shortcutItem.type isEqualToString:@"com.qk.share"])
    {
        NSLog(@"分享");
        NSArray *arr = @[@"hello 3D Touch"];
        
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        
        //设置当前的VC 为rootVC
        
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
            
        }];
        
        
    }else if ([shortcutItem.type isEqualToString:@"com.qk.search"])
    {
        NSLog(@"搜索");
        
    }else if ([shortcutItem.type isEqualToString:@"com.qk.compose"])
    {
        NSLog(@"新消息");
        
    }
    
}

-(void)shortcutItem
{
    
    if ([UIApplication sharedApplication].shortcutItems.count) {
        return;
    }
    
    // 分享 已在Info.plist里面设置
    NSMutableArray *shortcutItemArr = [NSMutableArray arrayWithArray:[UIApplication sharedApplication].shortcutItems];
    
    UIApplicationShortcutItem *shortcutItem1 = [[UIApplicationShortcutItem alloc]initWithType:@"com.qk.search" localizedTitle:@"搜索" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
    [shortcutItemArr addObject:shortcutItem1];
    
    UIApplicationShortcutItem *shortcutItem2 = [[UIApplicationShortcutItem alloc]initWithType:@"com.qk.compose" localizedTitle:@"新消息" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose] userInfo:nil];
    [shortcutItemArr addObject:shortcutItem2];
    
    [UIApplication sharedApplication].shortcutItems = shortcutItemArr;
    
    //以下打印值不包含Info.plist里面的设置
    NSLog(@"shortcutItems.count：%lu",[UIApplication sharedApplication].shortcutItems.count);
    
}


//- (void)application:(UIApplication *)application
//handleEventsForBackgroundURLSession:(NSString *)identifier
//  completionHandler:(nonnull void (^)(void))completionHandler
//{
//    NSLog(@"handleEventsForBackgroundURLSession");
//    [self initLocalNotification:@"handleEventsForBackgroundURLSession"];
//
//
//}
//- (void)URLSession:(NSURLSession *)session
//              task:(NSURLSessionTask *)task
//didCompleteWithError:(NSError *)error {
//
//    if (error) {
//        // check if resume data are available
//        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
//            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
//            //通过之前保存的resumeData，获取断点的NSURLSessionTask，调用resume恢复下载
//            //            self.resumeData = resumeData;
//        }
//    } else {
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate initLocalNotification:@"URLSessiondidCompleteWithError"];
//    }
//}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Background Fetch");
    
    
    [self initLocalNotification];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    
}

#pragma mark - Local Notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                    message:notification.alertBody
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
    // 图标上的数字
    application.applicationIconBadgeNumber = 0;
}

- (void)initLocalNotification {
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"iOS10通知";
        content.subtitle = @"新通知学习笔记";
        content.body = @"新通知变化很大，之前本地通知和远程推送是两个类，现在合成一个了。这是一条测试通知，";
        content.badge = @1;
        UNNotificationSound *sound = [UNNotificationSound soundNamed:UILocalNotificationDefaultSoundName];
        content.sound = sound;
        
        //第三步：通知触发机制。（重复提醒，时间间隔要大于60s）
        UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        
        //第四步：创建UNNotificationRequest通知请求对象
        NSString *requertIdentifier = @"RequestIdentifier";
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
        
        //第五步：将通知加到通知中心
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error:%@",error);
            
        }];
        
        
    }else
    {
        self.localNotification = [[UILocalNotification alloc] init];
        self.localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
        self.localNotification.alertAction = nil;
        self.localNotification.soundName = UILocalNotificationDefaultSoundName;
        self.localNotification.alertBody = @"Background Fetch启动";
        self.localNotification.applicationIconBadgeNumber += 1;
        self.localNotification.repeatInterval = 0;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
    }
    
    
    
}
@end

