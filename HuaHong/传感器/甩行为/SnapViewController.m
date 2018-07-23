//
//  SnapViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/7/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "SnapViewController.h"

@interface SnapViewController ()
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIDynamicAnimator *animator;
@end

@implementation SnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *t= touches.anyObject;
    CGPoint point = [t locationInView:self.view];
    
    //1.根据某一个范围，创建动画者对象
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //2.根据某个动力学元素，创建行为
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self.redView snapToPoint:point];
    
    //damping (0~1)越小，晃动幅度越大
    snap.damping = 0.5;
    
    //3.把行为添加到动画者中
    [self.animator addBehavior:snap];
}


@end
