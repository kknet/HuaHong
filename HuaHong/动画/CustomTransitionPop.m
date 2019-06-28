//
//  CustomTransitionPop.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/1.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CustomTransitionPop.h"

@interface CustomTransitionPop()
@property (nonatomic,strong) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation CustomTransitionPop

#pragma mark - UIViewControllerAnimatedTransitioning
//动画时长
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.66;
}

//动画内容
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
//    TransitionController *fromVC = (TransitionController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//
//    AnimationController *toVC = (AnimationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:fromVC.view.center radius:kScreenHeight/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:toVC.view.center radius:10 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endPath.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)(startPath.CGPath);
    animation.toValue = (__bridge id)(endPath.CGPath);
    animation.duration = [self transitionDuration:transitionContext];
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:animation forKey:@"pingInvert"];
    
    
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitionContext completeTransition:!self.transitionContext.transitionWasCancelled];
    
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}
@end
