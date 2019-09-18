//
//  MBProgressHUD+add.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/26.
//  Copyright © 2018年 huahong. All rights reserved.
//
#import "MBProgressHUD.h"
#import "UIViewController+MBProgressHUD.h"

@interface MBProgressHUD (add)

//MARK: - 警告提示信息
+(void)showMessage:(NSString *)message;
+(void)showMessage:(NSString *)message toView:(UIView *)view;

//MARK: - 成功提示信息
+(void)showSuccess:(NSString *)message;
+(void)showSuccess:(NSString *)message toView:(UIView *)view;

//MARK: - 失败提示信息
+(void)showError:(NSString *)message;
+(void)showError:(NSString *)message toView:(UIView *)view;

//MARK: - 显示加载框
+(void)showLoading:(NSString *)message;
+(void)showLoading:(NSString *)message toView:(UIView *)view;

//MARK: - 隐藏加载框
+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

//测试
//+ (void)progress;

@end
