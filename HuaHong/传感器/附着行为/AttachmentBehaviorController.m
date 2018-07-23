//
//  AttachmentBehaviorController.m
//  HuaHong
//
//  Created by 华宏 on 2018/7/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "AttachmentBehaviorController.h"
#import "BGView.h"

@interface AttachmentBehaviorController ()
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIView *greenView;
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIAttachmentBehavior *attachment;

@end

@implementation AttachmentBehaviorController
-(void)loadView
{
    self.view = [[BGView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    self.redView.alpha = 0.5;
    
//    self.greenView = [[UIView alloc]initWithFrame:CGRectMake(100, 300, 50, 50)];
//    self.greenView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:self.greenView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *t= touches.anyObject;
    CGPoint point = [t locationInView:t.view];
    
    //1.根据某一个范围，创建动画者对象
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //2.根据某个动力学元素，创建行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[self.redView]];
    
//    self.attachment = [[UIAttachmentBehavior alloc]initWithItem:self.redView attachedToAnchor:point];
    
    self.attachment = [[UIAttachmentBehavior alloc]initWithItem:self.redView offsetFromCenter:UIOffsetMake(-30, -30) attachedToAnchor:point];

//    self.attachment = [[UIAttachmentBehavior alloc]initWithItem:self.redView attachedToItem:self.greenView];
    
    //附着杆的长度
    _attachment.length = 200;
    
    //频率，使之变为弹性附着
    _attachment.frequency = 0.5;
    
    //3.把行为添加到动画者中
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:_attachment];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *t= touches.anyObject;
    CGPoint point = [t locationInView:t.view];
    
    self.attachment.anchorPoint = point;
    
    self.attachment.anchorPoint = point;
    
    __weak typeof(self) weakSelf = self;

    [self.attachment setAction:^{
      
        BGView *bgView = (BGView *)weakSelf.view;
        bgView.start = weakSelf.redView.center;
        bgView.end = point;
        [weakSelf.view setNeedsDisplay];
        
    }];
}

@end
