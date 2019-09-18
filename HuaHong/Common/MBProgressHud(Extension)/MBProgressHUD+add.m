//
//  MBProgressHUD+add.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/26.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MBProgressHUD+add.h"

#define kAfterDelay 2.0f
@implementation MBProgressHUD (add)

//MARK: - 警告提示信息
+(void)showMessage:(NSString *)message
{
    UIViewController *vc = [HUtils currentViewController];
    [[self class] showMessage:message toView:vc.view];
}

+(void)showMessage:(NSString *)message toView:(UIView *)view
{
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *imageName = [NSString stringWithFormat:@"info@%zdx.png",scale];
    [self p_show:message icon:imageName view:view];
}

//MARK: - 成功提示信息
+(void)showSuccess:(NSString *)message
{
    UIViewController *vc = [HUtils currentViewController];
    [[self class] showSuccess:message toView:vc.view];
}

+(void)showSuccess:(NSString *)message toView:(UIView *)view
{
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *imageName = [NSString stringWithFormat:@"success@%zdx.png",scale];
    [self p_show:message icon:imageName view:view];
}

//MARK: - 失败提示信息
+(void)showError:(NSString *)message
{
    UIViewController *vc = [HUtils currentViewController];
    [[self class] showError:message toView:vc.view];
}

+(void)showError:(NSString *)message toView:(UIView *)view
{
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *imageName = [NSString stringWithFormat:@"error@%zdx.png",scale];
    [self p_show:message icon:imageName view:view];
}

//MARK: - 显示加载框
+(void)showLoading:(NSString *)message
{
    UIViewController *vc = [HUtils currentViewController];
    [[self class] showLoading:message toView:vc.view];
}

+(void)showLoading:(NSString *)message toView:(UIView *)view
{

    view = view ?: [[UIApplication sharedApplication].windows lastObject];
    
    //设置菊花框为白色
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    
    //修改样式，否则等待框背景色将为半透明
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    
}

//MARK: - 隐藏加载框
+ (void)hideHUD
{
    UIViewController *vc = [HUtils currentViewController];
    [[self class] hideHUDForView:vc.view];
}

+ (void)hideHUDForView:(UIView *)view
{
    view = view ?: [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

//MARK: - 私有方法
/**
 在view上展示文字、图片
 
 @param text 所要展示的文字
 @param icon 所要展示的图片名称
 @param view 所要在哪个view上展示
 */
+(void)p_show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
   view = view ?: [[UIApplication sharedApplication].windows lastObject];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@",icon]]];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 30;
    hud.removeFromSuperViewOnHide = YES;
    
    //修改样式，否则等待框背景色将为半透明
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    
    [hud hideAnimated:YES afterDelay:kAfterDelay];
    
    
}

+ (void)progress
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text = @"正在加载中...";
    
    hud.progress = 0;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:1 block:^(NSTimer * _Nonnull timer) {
        
        hud.progress += 0.05 ;
        
        if (hud.progress >= 1.0) {
            [hud hideAnimated:YES];
        }
    }];
    
    [timer fire];
}

@end
