//
//  TransitionController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/1.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TransitionController.h"
#import "CustomTransitionPop.h"
#import "CustomTransitionPop.h"
@interface TransitionController ()<UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,assign) NSInteger imageIndex;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransition;
@end

@implementation TransitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageIndex = 1;
}

/**
 fade                  交叉淡化过渡
 push                  新视图将旧视图推出去
 movein                将旧视图移到新视图上面
 reveal                将旧视图移开，显示下面的新视图
 cube                  立方体反转
 oglflip               上下左右翻转
 suckEffect            收缩
 rippleEffect          水滴
 pageCurl              向上翻页
 pageUnCurl            向下翻页
 cameraIrisHollowOpen  相机打开
 cameraIrisHollowClose 相机关闭
 */
- (IBAction)transitionAction:(UISwipeGestureRecognizer *)sender
{
    self.imageIndex ++;
    if (self.imageIndex == 6) {
        self.imageIndex = 1;
    }
    
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%02ld",(long)self.imageIndex]];
    
    CATransition *transition = [[CATransition alloc]init];
    transition.type = @"cube";
    transition.subtype = (sender.direction == UISwipeGestureRecognizerDirectionLeft)?kCATransitionFromRight:kCATransitionFromLeft;
    [self.imageView.layer addAnimation:transition forKey:nil];
}

#pragma mark - 转场动画返回
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.delegate = self;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return [CustomTransitionPop new];
    }
    
    return nil;
}
@end
