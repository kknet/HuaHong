//
//  QKPrivacyManager.h
//  QKPrivacyManager
//
//  Created by wsj on 2019/3/22.
//  Copyright © 2019 wsj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QKPrivacyType)
{
    QKPrivacyType_LocationServices       =0,    // 定位服务
    QKPrivacyType_Contacts                 ,    // 通讯录
    QKPrivacyType_Calendars                ,    // 日历
    QKPrivacyType_Reminders                ,    // 提醒事项
    QKPrivacyType_Photos                   ,    // 照片
    QKPrivacyType_BluetoothSharing         ,    // 蓝牙共享
    QKPrivacyType_Microphone               ,    // 麦克风
    QKPrivacyType_SpeechRecognition        ,    // 语音识别 >= iOS10
    QKPrivacyType_Camera                   ,    // 相机
    QKPrivacyType_Health                   ,    // 健康 >= iOS8.0
    QKPrivacyType_HomeKit                  ,    // 家庭 >= iOS8.0
    QKPrivacyType_MediaAndAppleMusic       ,    // 媒体与Apple Music >= iOS9.3
    QKPrivacyType_MotionAndFitness         ,    // 运动与健身
    
};

//对应类型权限状态，参考PHAuthorizationStatus等
typedef NS_ENUM(NSInteger, QKAuthStatus)
{
    /** 用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权 */
    QKAuthStatus_NotDetermined  = 0,
    /** 已授权 */
    QKAuthStatus_Authorized     = 1,
    /** 拒绝 */
    QKAuthStatus_Denied         = 2,
    /** 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制 */
    QKAuthStatus_Restricted     = 3,
    /** 硬件等不支持 */
    QKAutStatus_NotSupport     = 4,
    
};

//定位权限状态，参考CLAuthorizationStatus
typedef NS_ENUM(NSUInteger, QKLocationAuthStatus){
    QKLocationAuthStatus_NotDetermined         = 0, // 用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权
    QKLocationAuthStatus_Authorized            = 1, // 一直允许获取定位 ps：< iOS8用
    QKLocationAuthStatus_Denied                = 2, // 拒绝
    QKLocationAuthStatus_Restricted            = 3, // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    QKLocationAuthStatus_NotSupport            = 4, // 硬件等不支持
    QKLocationAuthStatus_AuthorizedAlways      = 5, // 一直允许获取定位
    QKLocationAuthStatus_AuthorizedWhenInUse   = 6, // 在使用时允许获取定位
};

//蓝牙状态，参考 CBManagerState
typedef NS_ENUM(NSUInteger, QKCBManagerStatus){
    QKCBManagerStatusUnknown         = 0,        // 未知状态
    QKCBManagerStatusResetting       = 1,        // 正在重置，与系统服务暂时丢失
    QKCBManagerStatusUnsupported     = 2,        // 不支持蓝牙
    QKCBManagerStatusUnauthorized    = 3,        // 未授权
    QKCBManagerStatusPoweredOff      = 4,        // 关闭
    QKCBManagerStatusPoweredOn       = 5,        // 开启并可用
};


/**
 对应类型隐私权限状态回调block
 
 @param granted 是否授权
 @param status 授权的具体状态
 */
typedef void (^ResultBlock) (BOOL granted,QKAuthStatus status);



/**
 定位状态回调block
 
 @param status 授权的具体状态
 */
typedef void(^LocationResultBlock)(QKLocationAuthStatus status);



/**
 蓝牙状态回调block
 
 @param status 授权的具体状态
 */
typedef void(^BluetoothResultBlock)(QKCBManagerStatus status);



@interface QKPrivacyManager : NSObject

+(instancetype)shareManager;

@property (nonatomic, assign) QKPrivacyType PrivacyType;
@property (nonatomic, assign) QKAuthStatus AuthStatus;
@property (nonatomic, assign) QKCBManagerStatus CBManagerStatus;


/**
 检查和请求对应类型的隐私权限
 
 @param type 类型
 @param isPushSetting 当拒绝时是否跳转设置界面开启权限 (为NO时 只提示信息)
 @param ResultBlock 对应类型状态回调
 */
- (void)CheckPrivacyAuthWithType:(QKPrivacyType)type
                   isPushSetting:(BOOL)isPushSetting
                      withHandle:(ResultBlock)ResultBlock;



/**
 检查和请求 定位权限
 
 @param isPushSetting 当拒绝时是否跳转设置界面开启权限 (为NO时 只提示信息)
 @param ResultBlock 定位状态回调
 */
- (void)CheckLocationAuthWithisPushSetting:(BOOL)isPushSetting
                                withHandle:(LocationResultBlock)ResultBlock;


/**
 检查和请求 蓝牙权限
 
 @param isPushSetting 当拒绝时是否跳转设置界面开启权限 (为NO时 只提示信息)
 @param ResultBlock 蓝牙状态回调
 */
- (void)CheckBluetoothAuthWithisPushSetting:(BOOL)isPushSetting
                                 withHandle:(BluetoothResultBlock)ResultBlock;



/**
 检测通知权限状态
 
 @param isPushSetting 当拒绝时是否跳转设置界面开启权限 (为NO时 只提示信息)
 */
- (void)CheckNotificationAuthWithisPushSetting:(BOOL)isPushSetting;


/**
 注册通知
 */
+(void)RequestNotificationAuth;

@end

NS_ASSUME_NONNULL_END
