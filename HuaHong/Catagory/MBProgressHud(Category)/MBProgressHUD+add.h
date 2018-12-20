//
//  MBProgressHUD+add.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/26.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (add)

+(void)showSuccess:(NSString *)success toView:(UIView *)view;

+(void)showError:(NSString *)error toView:(UIView *)view;

+(void)showLoading:(NSString *)text toView:(UIView *)view;

/** 返回的时候记得隐藏，否则会内存泄漏 */
+ (void)hideHUDForView:(UIView *)view;

//测试
+ (void)progress;

#pragma mark - SV加载框
//返回不了，作用域全屏
+ (void)showProgressTitle:(NSString *)title withType:(SVProgressHUDStyle)type;
+ (void)hideProgressTitle;

@end
