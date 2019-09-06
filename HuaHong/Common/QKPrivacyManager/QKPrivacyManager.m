//
//  QKPrivacyManager.m
//  QKPrivacyManager
//
//  Created by wsj on 2019/3/22.
//  Copyright © 2019 wsj. All rights reserved.
//

#import "QKPrivacyManager.h"
#import <AVFoundation/AVFoundation.h>            //相机/麦克风
#import <Photos/Photos.h>                        //相册
#import <CoreLocation/CoreLocation.h>            //定位
#import <CoreLocation/CLLocationManager.h>
#import <CoreBluetooth/CoreBluetooth.h>          //蓝牙
#import <Contacts/Contacts.h>                    //通讯录iOS9以后  之前用//#import <AddressBook/AddressBook.h>
#import <EventKit/EventKit.h>
#import <HealthKit/HealthKit.h>
#import <MediaPlayer/MediaPlayer.h>


//这里需要注意，我们最好写成这种形式（防止低版本找不到头文件出现问题）
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h> //通知
#endif

#define IOS10_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface QKPrivacyManager ()<UNUserNotificationCenterDelegate,CBCentralManagerDelegate,CLLocationManagerDelegate>

//隐私权限状态回调block
@property(nonatomic,copy) ResultBlock block;
//蓝牙状态回调block
@property(nonatomic,copy) BluetoothResultBlock bluetoothResultBlock;
//定位状态回调block
@property(nonatomic,copy) LocationResultBlock locationResultBlock;
@property (nonatomic,copy) void (^kCLCallBackBlock)(CLAuthorizationStatus state);



/*
 * 提示
 */
@property(nonatomic,strong) NSString *tipStr;

@property (strong, nonatomic) CBCentralManager *centralManager;   //蓝牙

@property (strong, nonatomic) CLLocationManager *locationManager; //定位

@end

@implementation QKPrivacyManager

+(instancetype)shareManager
{
    static QKPrivacyManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (share ==nil)
        {
            share = [[QKPrivacyManager alloc]init];
        }
    });
    return share;
}

/**
 获取权限
 
 @param type 类型
 @param isPushSetting 是否跳转设置界面开启权限 (为NO时 只提示信息)
 @param ResultBlock 回调
 */
- (void)CheckPrivacyAuthWithType:(QKPrivacyType)type isPushSetting:(BOOL)isPushSetting withHandle:(ResultBlock)ResultBlock{
    
    self.block = ResultBlock;
    switch (type) {
            
        case QKPrivacyType_Photos:
        {   // 相册
            _tipStr = @"请在iPhone的“设置-隐私-相册”选项中开启权限";
            [self Auth_Photos:isPushSetting];
        }
            break;
        case QKPrivacyType_Camera:
        {   // 相机
            _tipStr = @"请在iPhone的“设置-隐私-相机”选项中开启权限";
            [self Auth_Camera:isPushSetting];
        }
            break;
        case QKPrivacyType_Microphone:
        {   // 麦克风
            _tipStr = @"请在iPhone的“设置-隐私-麦克风”选项中开启权限";
            [self Auth_Microphone:isPushSetting];
            
        }
            break;
        case QKPrivacyType_Contacts:
        {   // 通讯录
            _tipStr = @"请在iPhone的“设置-隐私-通讯录”选项中开启权限";
            [self Auth_Contacts:isPushSetting];
        }
            break;
        case QKPrivacyType_Calendars:
        {   // 日历
            _tipStr = @"请在iPhone的“设置-隐私-日历”选项中开启权限";
            [self Auth_Calendars:isPushSetting];
        }
            break;
        case QKPrivacyType_Reminders:
        {    // 提醒事项
            _tipStr = @"请在iPhone的“设置-隐私-提醒事项”选项中开启权限";
            [self Auth_Reminders:isPushSetting];
        }
            break;
        case QKPrivacyType_SpeechRecognition:
        {   //语音识别
            
        }
            break;
        case QKPrivacyType_BluetoothSharing:
        {    // 蓝牙共享
            //            _tipStr =@"请在iPhone的“设置-隐私-蓝牙共享”选项中开启权限";
        }
            break;
        case QKPrivacyType_LocationServices:
        {   // 定位服务
            //            _tipStr = @"请在iPhone的“设置-隐私-定位服务”选项中开启权限";
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 相册权限
- (void)Auth_Photos:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    switch (authStatus) {
        case PHAuthorizationStatusNotDetermined:
        {   //第一次进来
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    weakSelf.block(YES, QKAuthStatus_Authorized);
                } else {
                    weakSelf.block(NO, QKAuthStatus_Denied);
                    [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                }
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        {    //未授权，家长限制
            weakSelf.block(NO, QKAuthStatus_Restricted);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
            
        }
            break;
        case PHAuthorizationStatusDenied:
        {   //拒绝
            weakSelf.block(NO, QKAuthStatus_Denied);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {   //已授权
            weakSelf.block(YES, QKAuthStatus_Authorized);
        }
            break;
            
        default:
            break;
    }
    
    
    
}

#pragma mark - 相机权限
- (void)Auth_Camera:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined:
            {   //第一次进来
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    if (granted == YES) {
                        weakSelf.block(YES, QKAuthStatus_Authorized);
                    }else{
                        weakSelf.block(NO, QKAuthStatus_Denied);
                        [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                    }
                }];
            }
                break;
            case AVAuthorizationStatusRestricted:
            {   //未授权，家长限制
                weakSelf.block(NO, QKAuthStatus_Restricted);
                [self pushSetting:isPushSetting]; //拒绝时跳转或提示
            }
                break;
            case AVAuthorizationStatusDenied:
            {   //拒绝
                weakSelf.block(NO, QKAuthStatus_Denied);
                [self pushSetting:isPushSetting]; //拒绝时跳转或提示
            }
                break;
            case AVAuthorizationStatusAuthorized:
            {   //已授权
                weakSelf.block(YES, QKAuthStatus_Authorized);
            }
                break;
            default:
                break;
        }
        
        
        
    }else{
        //硬件不支持
        weakSelf.block(NO, QKAutStatus_NotSupport);
        
        NSLog(@" 硬件不支持 ");
        
        //         [JhProgressHUD showText:@"硬件不支持"];
    }
    
}

#pragma mark - 麦克风权限
- (void)Auth_Microphone:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {   //第一次进来
            
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                
                if (granted == YES) {
                    weakSelf.block(YES, QKAuthStatus_Authorized);
                }else{
                    weakSelf.block(NO, QKAuthStatus_Denied);
                    [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                }
            }];
            
        }
            break;
        case AVAuthorizationStatusRestricted:
        {   //未授权，家长限制
            weakSelf.block(NO, QKAuthStatus_Restricted);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case AVAuthorizationStatusDenied:
        {   //拒绝
            weakSelf.block(NO, QKAuthStatus_Denied);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {   //已授权
            weakSelf.block(YES, QKAuthStatus_Authorized);
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 通讯录权限
- (void)Auth_Contacts:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (authStatus) {
        case CNAuthorizationStatusNotDetermined:
        {   //第一次进来
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted == YES) {
                    weakSelf.block(YES, QKAuthStatus_Authorized);
                }else{
                    weakSelf.block(NO, QKAuthStatus_Denied);
                    [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                }
            }];
        }
            break;
        case CNAuthorizationStatusRestricted:
        {   //未授权，家长限制
            weakSelf.block(NO, QKAuthStatus_Restricted);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case CNAuthorizationStatusDenied:
        {   //拒绝
            weakSelf.block(NO, QKAuthStatus_Denied);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case CNAuthorizationStatusAuthorized:
        {   //已授权
            weakSelf.block(YES, QKAuthStatus_Authorized);
        }
            break;
        default:
            break;
    }
    
    
}
#pragma mark - 日历权限
- (void)Auth_Calendars:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    EKEntityType type  = EKEntityTypeEvent;
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:type];
    switch (authStatus) {
        case EKAuthorizationStatusNotDetermined:
        {   //第一次进来
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted == YES) {
                    weakSelf.block(YES, QKAuthStatus_Authorized);
                }else{
                    weakSelf.block(NO, QKAuthStatus_Denied);
                    [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                }
            }];
            
        }
            break;
        case EKAuthorizationStatusRestricted:
        {   //未授权，家长限制
            weakSelf.block(NO, QKAuthStatus_Restricted);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case EKAuthorizationStatusDenied:
        {   //拒绝
            weakSelf.block(NO, QKAuthStatus_Denied);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case EKAuthorizationStatusAuthorized:
        {   //已授权
            weakSelf.block(YES, QKAuthStatus_Authorized);
        }
            break;
        default:
            break;
    }
    
    
    
}

#pragma mark - 提醒事项权限
- (void)Auth_Reminders:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    EKEntityType type  = EKEntityTypeReminder;
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:type];
    switch (authStatus) {
        case EKAuthorizationStatusNotDetermined:
        {   //第一次进来
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted == YES) {
                    weakSelf.block(YES, QKAuthStatus_Authorized);
                }else{
                    weakSelf.block(NO, QKAuthStatus_Denied);
                    [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                }
            }];
            
        }
            break;
        case EKAuthorizationStatusRestricted:
        {   //未授权，家长限制
            weakSelf.block(NO, QKAuthStatus_Restricted);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case EKAuthorizationStatusDenied:
        {   //拒绝
            weakSelf.block(NO, QKAuthStatus_Denied);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case EKAuthorizationStatusAuthorized:
        {   //已授权
            weakSelf.block(YES, QKAuthStatus_Authorized);
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - 检查和请求 蓝牙权限
- (void)CheckBluetoothAuthWithisPushSetting:(BOOL)isPushSetting
                                 withHandle:(BluetoothResultBlock)ResultBlock{
    
    self.bluetoothResultBlock = ResultBlock;
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    _tipStr =@"请在iPhone的“设置-隐私-蓝牙共享”选项中开启权限";
    __weak typeof(self) weakSelf = self;
    switch (central.state) {
        case CBManagerStateUnknown:
        {    // 未知状态
            weakSelf.bluetoothResultBlock(QKCBManagerStatusUnknown);
            NSLog(@" 蓝牙状态 - 未知状态 ");
        }
            break;
        case CBManagerStateResetting:
        {   // 正在重置，与系统服务暂时丢失
            weakSelf.bluetoothResultBlock(QKCBManagerStatusResetting);
            NSLog(@" 蓝牙状态 - 正在重置，与系统服务暂时丢失 ");
        }
            break;
        case CBManagerStateUnsupported:
        {   // 不支持蓝牙
            weakSelf.bluetoothResultBlock(QKCBManagerStatusUnsupported);
            NSLog(@" 蓝牙状态 - 不支持蓝牙 ");
        }
            break;
        case CBManagerStateUnauthorized:
        {   // 未授权
            weakSelf.bluetoothResultBlock(QKCBManagerStatusUnauthorized);
            NSLog(@" 蓝牙状态 - 未授权 ");
        }
            break;
        case CBManagerStatePoweredOff:
        {   // 关闭
            weakSelf.bluetoothResultBlock(QKCBManagerStatusPoweredOff);
            NSLog(@" 蓝牙状态 - 关闭 ");
        }
            break;
        case CBManagerStatePoweredOn:
        {   // 开启并可用
            weakSelf.bluetoothResultBlock(QKCBManagerStatusPoweredOn);
            NSLog(@" 蓝牙 - 开启并可用 ");
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - 检查和请求 定位权限
- (void)CheckLocationAuthWithisPushSetting:(BOOL)isPushSetting
                                withHandle:(LocationResultBlock)ResultBlock{
    
    self.locationResultBlock = ResultBlock;
    __weak typeof(self) weakSelf = self;
    
    BOOL isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];
    if (!isLocationServicesEnabled) {
        NSLog(@"定位服务不可用，例如定位没有打开...");
        weakSelf.locationResultBlock(QKLocationAuthStatus_NotSupport);
        //        [JhProgressHUD showText:@"定位服务不可用"];
        
    }else{
        
        _tipStr = @"请在iPhone的“设置-隐私-定位服务”选项中开启权限";
        
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        switch (authStatus) {
            case kCLAuthorizationStatusNotDetermined:
            {   //第一次进来
                
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                
                // 两种定位模式：
                [self.locationManager requestAlwaysAuthorization];
                [self.locationManager requestWhenInUseAuthorization];
                
                [self setKCLCallBackBlock:^(CLAuthorizationStatus state){
                    if (authStatus == kCLAuthorizationStatusNotDetermined) {
                        weakSelf.locationResultBlock(QKLocationAuthStatus_NotDetermined);
                    }else if (authStatus == kCLAuthorizationStatusRestricted) {
                        //未授权，家长限制
                        weakSelf.locationResultBlock(QKLocationAuthStatus_Restricted);
                        [weakSelf pushSetting:isPushSetting]; //拒绝时跳转或提示
                        
                    }else if (authStatus == kCLAuthorizationStatusDenied) {
                        //拒绝
                        weakSelf.locationResultBlock(QKLocationAuthStatus_Denied);
                        [weakSelf pushSetting:isPushSetting]; //拒绝时跳转或提示
                    }else if (authStatus == kCLAuthorizationStatusAuthorizedAlways) {
                        //总是
                        weakSelf.locationResultBlock(QKLocationAuthStatus_AuthorizedAlways);
                    }else if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
                        //使用期间
                        weakSelf.locationResultBlock(QKLocationAuthStatus_AuthorizedWhenInUse);
                    }
                }];
                
                
                
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {   //未授权，家长限制
                weakSelf.locationResultBlock(QKLocationAuthStatus_Restricted);
                [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                
            }
                break;
            case kCLAuthorizationStatusDenied:
            {   //拒绝
                [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                weakSelf.locationResultBlock(QKLocationAuthStatus_Denied);
            }
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            {   //总是
                weakSelf.locationResultBlock(QKLocationAuthStatus_AuthorizedAlways);
            }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            {   //使用期间
                weakSelf.locationResultBlock(QKLocationAuthStatus_AuthorizedWhenInUse);
            }
                break;
            default:
                break;
        }
        
    }
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (self.kCLCallBackBlock) {
        self.kCLCallBackBlock(status);
    }
}



#pragma mark - 跳转设置
- (void)pushSetting:(BOOL)isPushSetting{
    
    if(isPushSetting ==YES){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未开启权限" message:[NSString stringWithFormat:@"%@",_tipStr] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url= [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (IOS10_OR_LATER) {
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
                    }];
                }
            }else{
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        }];
        [alert addAction:okAction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[QKPrivacyManager getCurrentVC] presentViewController:alert animated:YES completion:nil];
            
        });
        
        
    }else{
        
        NSLog(@" 可以添加弹框,弹框的提示信息:%@ ",_tipStr);
        
        //     [JhProgressHUD showText:_tipStr];
        
        
        
    }
    
    
}

#pragma mark - 获取当前VC
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}




#pragma mark - 检测通知权限状态
- (void)CheckNotificationAuthWithisPushSetting:(BOOL)isPushSetting;{
    
    _tipStr = @"请在iPhone的“设置-通知-”选项中开启通知权限";
    
    if (IOS10_OR_LATER) {
        //iOS 10 later
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusDenied)
            {
                NSLog(@" 通知权限 - 没开启 IOS10以后 ");
                [self pushSetting:isPushSetting];
                
                
            }else{
                NSLog(@" 通知权限 - 开了 IOS10以后  ");
            }
        }];
    }else{
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if(settings.types == UIUserNotificationTypeNone){
            NSLog(@" 通知权限 - 没开启 IOS10以前");
            [self pushSetting:isPushSetting];
            
        }else{
            NSLog(@" 通知权限 - 开了 IOS10以前");
        }
        
    }
    
    
    
}


#pragma mark - 注册通知
+ (void)RequestNotificationAuth{
    
    UIApplication *application = [UIApplication sharedApplication];
    if (IOS10_OR_LATER) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册ios10以上的通知 成功");
            }else{
                //用户点击不允许
                NSLog(@"注册ios10以上的通知 失败");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }else{
        //iOS10以前
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        
    }
    
    
    
}


@end
