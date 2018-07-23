//
//  PushBehaviorController.m
//  HuaHong
//
//  Created by 华宏 on 2018/7/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "PushBehaviorController.h"

@interface PushBehaviorController ()
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIDynamicAnimator *animator;
@end

@implementation PushBehaviorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *t= touches.anyObject;
    CGPoint point = [t locationInView:t.view];
    
    //1.根据某一个范围，创建动画者对象
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //2.根据某个动力学元素，创建行为
//    UIPushBehaviorModeContinuous,持续推，越来越快
//    UIPushBehaviorModeInstantaneous,瞬时推，越来越慢
    UIPushBehavior *push = [[UIPushBehavior alloc]initWithItems:@[self.redView] mode:UIPushBehaviorModeInstantaneous];
    
    //方向
//    push.angle = M_PI_2;
    CGFloat offsetX = point.x - self.redView.center.x;
    CGFloat offsetY = point.y - self.redView.center.y;

    push.pushDirection = CGVectorMake(-offsetX, -offsetY);

    
    //量级：
    push.magnitude = 1;
    
    //3.把行为添加到动画者中
    [self.animator addBehavior:push];
}


@end
