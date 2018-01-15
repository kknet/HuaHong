//
//  AppDelegate.h
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define BaiDuMapKey @"ln43SsPE7FxTDmQfFy7pwF9932a9hXCz"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

//定位服务
@property (nonatomic, assign) BOOL isStartLocation;
@property (nonatomic, copy)   NSString *address;
@property (nonatomic, assign) double latitude;//纬度
@property (nonatomic, assign) double longitude;//经度

- (void)saveContext;


@end

