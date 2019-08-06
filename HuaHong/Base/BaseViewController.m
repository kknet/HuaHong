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


//    //导航栏黑色
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    
//    //关闭导航栏半透明效果
//    self.navigationController.navigationBar.translucent = NO;
//    
//    //状态栏白色
////    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
//
//    //返回按钮文字
//    self.navigationController.navigationBar.topItem.title = @"返回";
//    
//    //返回按钮颜色
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    
//    //标题颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
//    
//    //导航栏颜色
//    self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
//    
//    self.navigationItem.title = @"title";
    
    /**
     * 1.在 viewDidLoad方法中，不能使用superView，因为view的get方法还没有走完，肯定没有添加到其他视图上//superview:(null)
     * 2.在init方法中 不应该出现 self.view 。否则数据还没有加载，就已经调用了viewDidLoad
     */
    
    NSLog(@"superview:%@",self.view.superview);
    
    
    //    self.navigationController.hidesBarsOnSwipe = YES;
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *title = NSLocalizedString(@"title", @"注释");
}

// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton
{
    return YES;
}

// 导航栏是否消失
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

//后台拉取回调
-(void)completationHandler:(void (^)(UIBackgroundFetchResult))completationHandler
{
    NSLog(@"UIBackgroundFetchResultNewData");
    completationHandler(UIBackgroundFetchResultNewData);
}

//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return YES;
//}

//- (void)setTitle:(NSString *)title
//{
//    FBShimmeringView *fbView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
//    fbView.shimmering = YES;//是否发光
//    fbView.shimmeringOpacity = 0;//透明度
//    fbView.shimmeringBeginFadeDuration = 0.3;
//    fbView.shimmeringEndFadeDuration = 2;
//    fbView.shimmeringAnimationOpacity = 0.6;
////    fbView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:fbView.bounds];
//    label.text = title;
//    label.textColor = [UIColor purpleColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont boldSystemFontOfSize:18];
//    label.backgroundColor = [UIColor clearColor];
//    fbView.contentView = label;
//    
//    self.navigationItem.titleView = fbView;
//}
@end
