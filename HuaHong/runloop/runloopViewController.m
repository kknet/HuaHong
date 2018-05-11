//
//  runloopViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/4.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "runloopViewController.h"

@interface runloopViewController ()

@end

@implementation runloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self runtimeAddMethod];
}

-(void)runtimeAddMethod
{
    //动态添加方法
    runtimeViewController *vc = [runtimeViewController new];
    [vc eat:@"123"];
}



@end
