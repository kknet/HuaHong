//
//  AnimationController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/19.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "AnimationController.h"

@interface AnimationController ()
//@property (nonatomic,strong) UIView *aniView;
@property (nonatomic,assign) BOOL isShowing;
@end

@implementation AnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    _isShowing = NO;
   
//    CGFloat width = 100;
//    CGRect viewframe = CGRectMake(([UIScreen mainScreen].bounds.size.width - width) / 2, 150, width, width);
//    _aniView = [[UIView alloc] initWithFrame:viewframe];
//    [self.view addSubview:_aniView];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_isShowing)
    {
        [self dismiss];
    }else
    {
        [self show];
    }
}

-(void)show
{
    [self.view.layer addSublayer:[self replicatorLayer_Round]];
    _isShowing = YES;
}

-(void)dismiss
{
    for (CALayer *layer in self.view.layer.sublayers) {
        [layer removeFromSuperlayer];
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
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
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

@end
