//
//  ChainViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "ChainViewController.h"
#import "NSObject+Calculation.h"

@implementation ChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
   int value = [NSObject Calculate:^(CalculateManager *manager) {
       
       manager.add(1).add(2).add(3).add(4);
    }];
    
    NSLog(@"value:%d",value);
}


@end
