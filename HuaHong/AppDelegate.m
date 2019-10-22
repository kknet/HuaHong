//
//  AppDelegate.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "AppDelegate.h"
//#import <AVOSCloud/AVOSCloud.h>
//#import "FaceppAPI.h"
#import "AppDelegate+Notification.h"
#import "TabBarViewController.h"
#import "LocationManager.h"
#import "HomeVC.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMConfigure.h>
#import <Bugly/Bugly.h>
#import <Aspects/Aspects.h>

@interface AppDelegate ()

@end
#define AppID_LeanCloud @"MzO33NdKfaN8ceAKO1IBHEGa-gzGzoHsz"
#define AppKey_LeanCloud @"jkiMcMrIVxUE2JpJoPeWmKQ4"
#define AppKey_Face @"i2v1x_zCb8P8rx7OtgtJ2O6fpNLyLFl5"
#define AppSecret_Face @"5f34UqXdZjz7f64yDpFUQoOQJyxwHtye"
#define UMAppKey @"5ac9dba3b27b0a6c82000085"

@implementation AppDelegate



/** 输出异常 */
static void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"%@/n%@", exception, [exception callStackSymbols]);
    
}

- (void)BuglyConfig
{
    [Bugly startWithAppId:@"13930b836d"];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configRequestManager];
    
    [self BuglyConfig];
    
  /** 输出异常 */
NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
//    NSLog(@"launch time :%f 秒",CFAbsoluteTimeGetCurrent()-startTime);
    [self setApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    /*
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [self.window makeKeyAndVisible];

    TabBarViewController *tabBarVC = [[TabBarViewController alloc]init];
    self.window.rootViewController = tabBarVC;
    
     */
    
    [LocationManager sharedLocationManager];
    
    [self shortcutItem];
    
    //长亮
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];

    //BackgroundFetch
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    
    [self baiduMap];

    //云端存储
    [self leanCloud];

    //人脸识别
    [self face];

    // U-Share 平台设置
    [self configUSharePlatforms];
    
    /** 设置缓存 */
    NSURLCache *cache = [[NSURLCache alloc]initWithMemoryCapacity:1012*1024*5 diskCapacity:1012*1024*10 diskPath:@"images"];
    [NSURLCache setSharedURLCache:cache];
    
    return YES;
}

#pragma mark 此方法用于处理应用间跳转的 XCode9.3废弃
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    //1. 获取跟控制器, 执行跳转
//    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    // 主控制器
//    UIViewController *mainVC =  nav.childViewControllers[0];
//
//    //2. 回到根控制器
//    [nav popToRootViewControllerAnimated:YES];
    
    NSLog(@"openURL:%@",url);//wxdefc667f64adc83a://platformId=wechat
    
    
    //1. 获取 URL
    NSString *URLStr = url.absoluteString;
    
    //2. 判断是否包含指定的关键词
    if ([URLStr containsString:@"session"])
    {
        //3. 根据关键词跳转指定的界面
    }
    
//    //Umeng
//6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
if (!result) {
     // 其他如支付等SDK的回调
}
return result;
    
    
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [MBProgressHUD showMessage:@"欢迎回来"];
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
//    HomeVC *homeVC = [HomeVC new];
//    [homeVC completationHandler:completionHandler];
    
}

-(void)leanCloud
{
    
//    [AVOSCloud setApplicationId:AppID_LeanCloud clientKey:AppKey_LeanCloud];
//    
//    [AVOSCloud setAllLogsEnabled:NO];

}

-(void)face
{
//    // 初始化 SDK
//    [FaceppAPI initWithApiKey:AppKey_Face andApiSecret:AppSecret_Face
//                    andRegion:APIServerRegionCN];
//
//    /// 开始 Debug 模式
//    // 如果设置 YES, 就会输出打印信息
//    [FaceppAPI setDebugMode:NO];
}

-(void)updateVersion
{
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"LocalVersion:%@",localVersion);
    NSString *onlineVersion = @"8.8.1.0";
    if ([localVersion compare:onlineVersion options:NSNumericSearch] == NSOrderedDescending) {
        //降序
        NSLog(@"%@  >  %@",localVersion,onlineVersion);
    }else if ([localVersion compare:onlineVersion options:NSNumericSearch] == NSOrderedAscending){
        //升序
        NSLog(@"%@  <  %@",localVersion,onlineVersion);
    }else if ([localVersion compare:onlineVersion options:NSNumericSearch] == NSOrderedSame){
        
        NSLog(@"%@  =  %@",localVersion,onlineVersion);
        
    }
    NSError *error;
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=1116017277"];
    NSURLRequest *request= [NSURLRequest requestWithURL:url];
    NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dict=  [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    NSArray *results= [dict objectForKey:@"results"];
    if([results count])
    {
        NSDictionary *resDict= [results objectAtIndex:0];
        NSString *newVersion = [resDict objectForKey:@"version"];
        NSString *trackViewUrl=[resDict objectForKey:@"trackViewUrl"];
        
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:trackViewUrl]];
        });
    }
}


- (void)configRequestManager
{
    [[HHRequestManager defaultManager] startNetMonitoring];
    
    //请求结果过滤NSNull
    [[HHRequestManager defaultManager]setFilterResponseCallback:^(id _Nonnull data, void (^ _Nonnull continueResponseBlock)(id _Nonnull)) {
        
        id result = data;
        if ([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSMutableDictionary class]]) {
            
            NSDictionary *dic = (NSDictionary *)data;
            result = [dic filterNull];
            
        }else if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSMutableArray class]]){
            
            NSArray *array = (NSArray *)data;
            result = [array filterNull];
        }
        
        continueResponseBlock(result);
    }];
}

- (void)configUSharePlatforms
{
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = YES;
    
//    [UMSocialManager defaultManager].umSocialAppkey = UMAppKey;
    [UMConfigure initWithAppkey:UMAppKey channel:@"App Store"];
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdefc667f64adc83a" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
}

@end

