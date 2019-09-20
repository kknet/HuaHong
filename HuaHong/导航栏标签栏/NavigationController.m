//
//  NavigationController.m
//  CustomTabBar
//
//  Created by 华宏 on 2017/11/28.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决自定义返回按钮后滑动手势失效的问题
    self.interactivePopGestureRecognizer.delegate = nil;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
}
+ (void)initialize
{
    //修改标题字体颜色及大小

//    UINavigationBar *bar = [UINavigationBar appearance];
    
//    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:25 / 255.0 green:153 / 255.0 blue:24 / 255.0 alpha:1.0]}];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0)
    {
//        [self creatBackButton:viewController];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    //这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
    //解决iPhone X push页面时 tabBar上移的问题
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
    
}

-(void)creatBackButton:(UIViewController *)viewController
{
    //自定义返回按钮
    UIImage *leftItemImage = [UIImage imageNamed:@"leftArrow"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    viewController.navigationItem.leftBarButtonItem = leftItem;
}
- (void)back
{

    [self popViewControllerAnimated:YES];

}

//支持设备自动旋转
-(BOOL)shouldAutorotate
{
    return YES;
}

@end
