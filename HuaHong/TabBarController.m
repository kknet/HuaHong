//
//  TabBarController.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "TabBarController.h"
#import "HomeVC.h"
#import "GongNengVC.h"
#import "KongJianVC.h"

@interface TabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,strong)UIButton *button;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarVC];
    [self setup];
    
}

- (void)setTabBarVC
{
    [self setTabBarChildController:[[GongNengVC alloc] init] title:@"功能" image:@"mes_icon" selectImage:@"mes_icon_sel"];
    
    
    [self setTabBarChildController:[[HomeVC alloc] init] title:@"" image:@"" selectImage:@""];
    
    [self setTabBarChildController:[[KongJianVC alloc] init] title:@"控件" image:@"personal_icon" selectImage:@"personal_icon_sel"];
    
    
}
- (void)setTabBarChildController:(UIViewController*)controller title:(NSString*)title image:(NSString*)imageStr selectImage:(NSString*)selectImageStr
{
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:[[UIImage imageNamed:imageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateSelected];
    
    nav.tabBarItem = item;
    
    [self addChildViewController:nav];
    
    self.selectedIndex = 1;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup
{
    //  添加突出按钮
    [self addCenterButtonWithImage:[UIImage imageNamed:@"home_icon"] selectedImage:[UIImage imageNamed:@"home_icon_sel"]];
    
    //  UITabBarControllerDelegate 指定为自己
    self.delegate=self;
    
    //  指定当前页——中间页
    self.selectedIndex=1;
    
    // 设点button状态
    _button.selected=YES;
    
}

#pragma mark - addCenterButton
// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage
{
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    _button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    //  设定button大小为适应图片
    _button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [_button setImage:buttonImage forState:UIControlStateNormal];
    [_button setImage:selectedImage forState:UIControlStateSelected];
    
    //  这个比较恶心  去掉选中button时候的阴影
    _button.adjustsImageWhenHighlighted=NO;
    /*
     *  核心代码：设置button的center 和 tabBar的 center 做对齐操作， 同时做出相对的上浮
     */
    CGPoint center = self.tabBar.center;
    center.y = center.y - buttonImage.size.height/8;
    _button.center = center;
    [self.view addSubview:_button];
    [self.view bringSubviewToFront:_button];
}

-(void)pressChange:(id)sender
{
    self.selectedIndex=1;
    _button.selected=YES;
}

#pragma mark- UITabBarControllerDelegate
//  换页和button的状态关联上
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.selectedIndex==1) {
        _button.selected=YES;
    }else
    {
        _button.selected=NO;
    }
}

@end
