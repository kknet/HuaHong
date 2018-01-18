//
//  AppDelegate.h
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
//#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#define BaiDuMapKey @"ln43SsPE7FxTDmQfFy7pwF9932a9hXCz"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong) BMKMapManager *mapManager;

//定位服务
@property (nonatomic, assign) BOOL isStartLocation;
@property (nonatomic, copy)   NSString *address;
@property (nonatomic, assign) double latitude;//纬度
@property (nonatomic, assign) double longitude;//经度

- (void)saveContext;


@end

