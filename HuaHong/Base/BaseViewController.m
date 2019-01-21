//
//  BaseViewController.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/24.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
//    self.shouldAutorotate = YES;
}

// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton
{
    return YES;
}

//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return YES;
//}

- (void)setTitle:(NSString *)title
{
    FBShimmeringView *fbView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
    fbView.shimmering = YES;//是否发光
    fbView.shimmeringOpacity = 0;//透明度
    fbView.shimmeringBeginFadeDuration = 0.3;
    fbView.shimmeringEndFadeDuration = 2;
    fbView.shimmeringAnimationOpacity = 0.6;
//    fbView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:fbView.bounds];
    label.text = title;
    label.textColor = [UIColor purpleColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    fbView.contentView = label;
    
    self.navigationItem.titleView = fbView;
}
@end
