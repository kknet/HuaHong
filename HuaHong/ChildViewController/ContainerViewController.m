//
//  ContainerViewController.m
//  HuaHong
//
//  Created by qk-huahong on 2019/8/6.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "ContainerViewController.h"
#import "ChildViewController.h"

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self addChildVC];
}

- (void)addChildVC
{
    
//    先调用addSubView，viewWillAppear和viewDidAppear会各调用一次，再addChildViewController，与父视图控制器的事件同步，即当父视图控制器的viewDidAppear调用时，childViewController的viewDidAppear方法会再调用一次。所以viewDidAppear方法被调用了两次。
//    先调用addChildViewController，childViewController的事件与父视图控制器同步，当父视图控制器的viewDidAppear调用时，childViewController的viewDidAppear方法会调用一次，再调用addSubView也不会触发viewWillAppear和viewDidAppear。
    
   
    //    父子视图控制器
    ChildViewController *vc1 = [[ChildViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.view.frame = CGRectMake(0, 0, self.view.width, self.view.height/2);
    [self addChildViewController:vc1];
    [self.view addSubview:vc1.view];
    [vc1 updateViewConstraints];
    
    
    ChildViewController *vc2 = [[ChildViewController alloc] init];
    vc2.view.backgroundColor = [UIColor purpleColor];
    [self addChildViewController:vc2];
    
    //从父视图控制器中移除,从self.childViewControllers移除
    //    [vc1 removeFromParentViewController];
    
    //    [vc1 willMoveToParentViewController:self];
    //    [vc1 didMoveToParentViewController:self];
    
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toRight)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toLeft)];
    swipe1.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe1];
}
-(void)toRight{
    
    //    从childViewControllers 数组中  获取子视图控制器
    UIViewController *vc1 = [self.childViewControllers firstObject];
    UIViewController *vc2 = [self.childViewControllers lastObject];
    
    //  通过默认动画交换 显示子控制器的视图 (vc1.view 会移除，vc2.view 添加到self.view上)
    [self transitionFromViewController:vc1 toViewController:vc2 duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)toLeft{
    
    //    从childViewControllers 数组中  获取子视图控制器
    UIViewController *vc1 = [self.childViewControllers firstObject];
    UIViewController *vc2 = [self.childViewControllers lastObject];
    
    //  通过默认动画交换 显示子控制器的视图 (vc1.view 会移除，vc2.view 添加到self.view上)
    [self transitionFromViewController:vc2 toViewController:vc1 duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

//- (void)updateScrollowBottomConstant:(CGFloat)bottom_Y {
//    _bottom_Y = bottom_Y;
//    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(bottom_Y);
//    }];
//}

@end
