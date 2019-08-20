//
//  AnimationController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/19.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "AnimationController.h"
#import "AnimationView.h"
#import "CustomTransitionPush.h"

@interface AnimationController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, assign) BOOL isShowing;
@end

@implementation AnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setValue:[AnimationView new] forKey:@"view"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"转场动画" style:UIBarButtonItemStylePlain target:self action:@selector(transitionAnimation)];
//    [rightItem setTintColor:[UIColor blackColor]];
//    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
//    [rightItem setTitlePositionAdjustment:0 forBarMetrics:nil];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    _redView = [[UIView alloc] initWithFrame:CGRectMake( 100, 150, 50, 50)];
    _redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_redView];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if (_isShowing)
//    {
//        [self dismiss];
//    }else
//    {
//        [self show];
//    }
    
//    [self test1];
//    [self test2];
    
    [self groupAnimation];
}

-(void)show
{
    [self.view.layer addSublayer:[self replicatorLayer_Round]];
    _isShowing = YES;
}

-(void)dismiss
{
    for (CALayer *layer in self.view.layer.sublayers) {
        if ([layer isKindOfClass:[CAReplicatorLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    _isShowing = NO;
    
}

// 转圈动画
- (CALayer *)replicatorLayer_Round{
    
    CALayer *layer = [[CALayer alloc]init];
    layer.frame = CGRectMake(0, 0, 12, 12);
    layer.cornerRadius = 6;
    layer.masksToBounds = YES;
    layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    //基本动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    
    //默认会回到原始状态，若不想回去，则：
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:nil];
    
    NSInteger instanceCount = 9;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(100, 200, 50, 50);
    replicatorLayer.preservesDepth = YES;
    replicatorLayer.instanceColor = [UIColor whiteColor].CGColor;
    replicatorLayer.instanceRedOffset = 0.1;
    replicatorLayer.instanceGreenOffset = 0.1;
    replicatorLayer.instanceBlueOffset = 0.1;
    replicatorLayer.instanceAlphaOffset = 0.1;
    replicatorLayer.instanceCount = instanceCount;
    replicatorLayer.instanceDelay = 1.0/instanceCount;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) /instanceCount, 0, 0, 1);
    [replicatorLayer addSublayer:layer];
    
    return replicatorLayer;
}

#pragma mark - 基本动画
-(void)test1
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.5;
    
    animation.fromValue = @(0.5);
    animation.toValue = @(2.5);
    
    //自身基础上自增
//    animation.byValue = @(1.5);
    
    //不返回原始状态
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
    
    animation.repeatCount = MAXFLOAT;
    
    [self.redView.layer addAnimation:animation forKey:nil];

    
}

#pragma mark - 关键帧动画
-(void)test2
{
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc]init];
//    animation.rotationMode = kCAAnimationCubic;
    animation.keyPath = @"position";
    
//    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(100, 150)];
//    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(300, 150)];
//    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(100, 350)];
//    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(300, 350)];
//
//    animation.values = @[value1,value2,value3,value4];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:100 startAngle:0 endAngle:2*M_PI clockwise:1];
    animation.path = path.CGPath;
    
    animation.repeatCount = MAXFLOAT;
    animation.duration = 0.5;
    
    [self.redView.layer addAnimation:animation forKey:nil];

}

#pragma mark - 组动画
-(void)groupAnimation
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    
    //基本动画
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basic.byValue = @(2*M_PI * 5);
    
    //关键帧动画
    CAKeyframeAnimation *keyframe = [[CAKeyframeAnimation alloc]init];
    keyframe.keyPath = @"position";
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2) radius:100 startAngle:0 endAngle:2*M_PI clockwise:1];
    keyframe.path = path.CGPath;
    
    group.animations = @[basic,keyframe];
    group.repeatCount = HUGE;
    group.duration = 1;
    [self.redView.layer addAnimation:group forKey:nil];
}

-(void)setBtnAnimation
{
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    
    pathAnimation.repeatCount = MAXFLOAT;
    pathAnimation.autoreverses=YES;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    pathAnimation.duration=6;
    
    UIBezierPath *path=[UIBezierPath bezierPathWithArcCenter:self.view.center radius:100 startAngle:0 endAngle:2*M_PI clockwise:1];
    
    pathAnimation.path=path.CGPath;
    
    //        [self.view.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
    
    
    
    CAKeyframeAnimation *scaleX=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    
    scaleX.values   = @[@1.0, @1.2, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5,@1.0];
    scaleX.repeatCount = MAXFLOAT;
    scaleX.autoreverses = YES;
    
    scaleX.duration=6;
    
    [self.view.layer addAnimation:scaleX forKey:@"scaleX"];
    
    
    CAKeyframeAnimation *scaleY=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    
    scaleY.values   = @[@1.0, @1.2, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5,@1.0];
    scaleY.repeatCount = MAXFLOAT;
    scaleY.autoreverses = YES;
    
    scaleY.duration=6;
    
    [self.view.layer addAnimation:scaleY forKey:@"scaleY"];
    
    
}

#pragma mark - 转场动画
-(void)transitionAnimation
{
    TransitionController *VC = [kStory instantiateViewControllerWithIdentifier:@"TransitionController"];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.delegate = self;
    
    //设置动画
    [self setBtnAnimation];
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        CustomTransitionPush *customPush = [CustomTransitionPush new];
        return customPush;
    }else
    {
        return nil;
    }
}

//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
//{
//    return nil;
//}
@end
