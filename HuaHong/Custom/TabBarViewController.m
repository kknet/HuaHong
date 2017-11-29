//
//  TabBarViewController.m
//  CustomTabBar
//
//  Created by 华宏 on 2017/11/28.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "TabBarViewController.h"
#import "NavigationController.h"
#import "HomeVC.h"
#import "GongNengVC.h"
#import "KongJianVC.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

+(void)initialize
{
    //设置未选中的TabBarItem的字体颜色、大小
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    //设置选中了的TabBarItem的字体颜色、大小
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:25 / 255.0 green:153 / 255.0 blue:24 / 255.0 alpha:1.0];
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    imageV.image = [UIImage imageNamed:@"tabBarLine"];
    imageV.contentMode = UIViewContentModeCenter;
    [self.tabBar addSubview:imageV];
    
    //中间自定义按钮
    UIButton *centerBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 60)/2, 49 - 60, 60, 60)];
//    centerBtn.userInteractionEnabled = NO;
    centerBtn.backgroundColor = [UIColor clearColor];
    centerBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    centerBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    [centerBtn setImage:[UIImage imageNamed:@"tabBarCenter"] forState:UIControlStateNormal];
//    [centerBtn setImage:[UIImage imageNamed:@"tabBarCenter"] forState:UIControlStateSelected];

//    [centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:centerBtn];
    
    [self setUpAllChildVc];
    
    self.selectedIndex = 1;
}

//-(void)centerBtnClick:(UIButton *)sender
//{
//    self.selectedIndex = 1;
//}
/**
 *  添加所有的控制器
 */
- (void)setUpAllChildVc
{
    [self setupChildVc:[[GongNengVC alloc] init] title:@"功能" image:@"mes_icon" selectedImage:@"mes_icon_sel"];
    
    
    [self setupChildVc:[[HomeVC alloc] init] title:@"Home" image:nil selectedImage:nil];
    
    
    [self setupChildVc:[[KongJianVC alloc] init] title:@"我的" image:@"personal_icon" selectedImage:@"personal_icon_sel"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.title = title;
    if (image || selectedImage) {
        vc.tabBarItem.image = [UIImage imageNamed:image];
        UIImage *selectImage = [UIImage imageNamed:selectedImage];
        vc.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
