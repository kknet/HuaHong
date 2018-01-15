//
//  LocationManager.h
//  HuaHong
//
//  Created by 华宏 on 2017/11/23.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic, assign) double latitude;//纬度
@property (nonatomic, assign) double longitude;//经度
@property (nonatomic, strong) NSDate *timestamp;//时间戳
@property (nonatomic, copy)  NSString *address;

+(instancetype)sharedLocationManager;

- (BOOL)isEnableLocation;

- (void)startLocation;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

@end
