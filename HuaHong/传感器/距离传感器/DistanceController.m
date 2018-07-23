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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
