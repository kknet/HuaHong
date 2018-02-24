//
//  AppDelegate.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Notification.h"
#import "TabBarViewController.h"
#import "LocationManager.h"
#import "HomeVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 * 连线UI控件都用weak修饰
 * NSString: 用copy修饰
 * Block:    用copy修饰
 * delegate: 用weak修饰
 * retain(mrc),strong(arc),weak(arc),assign(mrc,arc),copy(mrc,arc)
 */

/**
 * command+= :siziToFit
 * option+command+= :storyboard警告
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setApplication:application didFinishLaunchingWithOptions:launchOptions];
    
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

- (void)applicationWillTerminate:(UIApplication *)application {
    
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

//3DTouch
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


- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Background Fetch");
    
    
    [self setLocalNotification];
    
    //1.在此处理事件
//    completionHandler(UIBackgroundFetchResultNewData);
    
    //2.将事件传给HomeVC
    HomeVC *homeVC = [HomeVC new];
    [homeVC completationHandler:completionHandler];
    
}




@end

