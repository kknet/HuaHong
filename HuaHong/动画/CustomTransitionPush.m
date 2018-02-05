//
//  CustomTransitionPush.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/1.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CustomTransitionPush.h"

@interface CustomTransitionPush()
@property(nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation CustomTransitionPush

#pragma mark - UIViewControllerAnimatedTransitioning
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.66;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
//    AnimationController *fromVC = (AnimationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//
//    TransitionController *toVC = (TransitionController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:fromVC.view.center radius:100 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:toVC.view.center radius:kScreenHeight/2 startAngle:0 endAngle:2*M_PI clockwise:YES];;

    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    maskLayer.path = endPath.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)(startPath.CGPath);
    animation.toValue = (__bridge id)(endPath.CGPath);
    animation.duration = [self transitionDuration:transitionContext];
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:animation forKey:@"path"];
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitionContext completeTransition:YES];
    
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}
@end
