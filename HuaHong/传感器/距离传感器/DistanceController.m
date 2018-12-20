//
//  DistanceController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/15.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "DistanceController.h"

@interface DistanceController ()

@end

@implementation DistanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

-(void)proximityChange:(NSNotificationCenter *)notification
{
    if ([UIDevice currentDevice].proximityState == YES)
    {
        NSLog(@"某物体靠近设备，自动锁屏");
    }else
    {
      NSLog(@"某物体远离设备,屏幕解锁");
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
}


@end
