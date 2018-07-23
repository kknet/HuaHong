//
//  GravityViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/7/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "GravityViewController.h"

@interface GravityViewController ()
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIDynamicAnimator *animator;
@end

@implementation GravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //1.根据某一个范围，创建动画者对象
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //2.根据某个动力学元素，创建行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[self.redView]];
    
    //方向
//    gravity.gravityDirection = CGVectorMake(1, 1);
    gravity.angle = M_PI_2;
    
    //量级：速度
    gravity.magnitude = 1;
    
    //3.把行为添加到动画者中
    [self.animator addBehavior:gravity];
}


@end
