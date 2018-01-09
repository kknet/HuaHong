//
//  TabBarViewController.m
//  CustomTabBar
//
//  Created by 华宏 on 2017/11/28.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "TabBarViewController.h"
#import "HHTabBar.h"
#import "NavigationController.h"
#import "HomeVC.h"
#import "GongNengVC.h"
#import "KongJianVC.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic,strong) HHTabBar *myTabBar;
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
    
    self.myTabBar = [[HHTabBar alloc]init];
    self.delegate = self;
    
//    self.myTabBar.backgroundColor = [UIColor whiteColor];
//    透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    self.myTabBar.translucent = NO;

    [self.myTabBar.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_myTabBar forKey:@"tabBar"];
    
    [self setUpAllChildVc];
    
    self.selectedIndex = 1;
}

-(void)centerBtnClick:(UIButton *)sender
{
    self.selectedIndex = 1;
    [self rotationAnimation];
}
/**
 *  添加所有的控制器
 */
- (void)setUpAllChildVc
{
    [self setupChildVc:[[GongNengVC alloc] init] title:@"StoryBoard" image:@"mes_icon" selectedImage:@"mes_icon_sel"];
    
    
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

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 1) {
        [self rotationAnimation];

    }else
    {
        [_myTabBar.centerBtn.layer removeAllAnimations];
    }
}

//旋转动画
- (void)rotationAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 3.0;
    rotationAnimation.repeatCount = HUGE;
    [_myTabBar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
}
@end
