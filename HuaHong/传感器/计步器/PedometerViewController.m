//
//  PedometerViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/7/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "PedometerViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface PedometerViewController ()
@property (nonatomic,strong) CMPedometer *pedometer;
@end

@implementation PedometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (![CMPedometer isStepCountingAvailable]) {
        return;
    }
    
    _pedometer = [CMPedometer new];
    
    [_pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        
        NSLog(@"stepCount:%@",pedometerData.numberOfSteps);
    }];
}

@end
