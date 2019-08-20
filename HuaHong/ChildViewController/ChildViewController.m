//
//  ChildViewController.m
//  HuaHong
//
//  Created by qk-huahong on 2019/8/6.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()
@property (nonatomic, strong)UILabel *label;
@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
    label.text = @"测试";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    _label = label;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    _label.frame = self.view.bounds;
}

@end
