//
//  ViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "ButtonVC.h"

@implementation ButtonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatButton];
    
    
    
}

- (void)creatButton
{
    UIImage *image = [UIImage imageNamed:@"camera_flash_on"];

    CGFloat space = 0;// 图片和文字的间距
    NSString *title = @"测试测试测试";
    
    
    CGFloat btnWidth = 200;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, btnWidth, 100);
    button.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:button];
    button.center = self.view.center;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    

    
    [button layoutEdgeInsetsWithStyle:(ButtonEdgeInsetsStyleTop) Space:space];
    
}


@end
