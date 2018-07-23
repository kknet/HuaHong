//
//  CollisionViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/7/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CollisionViewController.h"
#import "BGView.h"

@interface CollisionViewController ()<UICollisionBehaviorDelegate> 
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIView *greenView;
@property (nonatomic,strong) UIDynamicAnimator *animator;
@end

@implementation CollisionViewController
-(void)loadView
{
    self.view = [[BGView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    BGView *bgView = (BGView *)self.view;
    bgView.start = CGPointMake(100, 250);
    bgView.end = CGPointMake(200, 300);
    [bgView setNeedsDisplay];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    
    self.greenView = [[UIView alloc]initWithFrame:CGRectMake(100, 300, 50, 50)];
    self.greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.greenView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //1.根据某一个范围，创建动画者对象
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //2.根据某个动力学元素，创建行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[self.redView]];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[self.redView,self.greenView]];
    
    //方向
    //    gravity.gravityDirection = CGVectorMake(1, 1);
    gravity.angle = M_PI_2;
    
    //量级：速度
    gravity.magnitude = 1;
    
    collision.translatesReferenceBoundsIntoBoundary = YES;
  
            /** 碰撞模式 */
//    UICollisionBehaviorModeItems 仅和Item碰撞
//    UICollisionBehaviorModeBoundaries 仅和边界碰撞
//    UICollisionBehaviorModeEverything Item和边界都碰撞
    collision.collisionMode = UICollisionBehaviorModeEverything;
    
    //添加边界
//    [collision addBoundaryWithIdentifier:@"key" forPath:[UIBezierPath bezierPathWithRect:self.greenView.frame]];
    
    [collision addBoundaryWithIdentifier:@"key" fromPoint:CGPointMake(100, 250) toPoint:CGPointMake(200, 300)];
    
    [collision setAction:^{
        NSLog(@"redViewFrame:%@",NSStringFromCGRect(self.redView.frame));
    }];
    
    collision.collisionDelegate = self;
    
    
    //动力学自身特性
    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc]initWithItems:@[self.redView,self.greenView]];
    
    //弹力
    item.elasticity = 0.5;
    
    //密度
    item.density = 0.5;
    
    //摩擦力
    item.friction = 0.5;
    
    //阻力
    item.resistance = 0;
    
    //3.把行为添加到动画者中
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
    [self.animator addBehavior:item];


}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p
{
   //item 与 item 开始碰撞
}
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2
{
    //item 与 item 结束碰撞
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p
{
    //item 与 边界 开始碰撞
    //如果和屏幕边缘碰撞，则identifier = nil
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier
{
    //item 与 边界 结束碰撞
}
@end
