//
//  UIViewController+Alert.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

/**
 弹出系统样式的UIAlertController
 @param title 标题
 @param target 目标控制器
 @param message 提示信息
 @param sureTitle 确定按钮文字
 @param cancelTitle 取消按钮文字
 @param sureHandel 确定的点击事件
 @param cancelHandel 取消点击事件
 */
+ (void)showAlertWhithTarget:(UIViewController *)target Title:(NSString *)title Message:(NSString *)message SureTitle:(NSString *)sureTitle CancelTitle:(NSString *)cancelTitle SureAction:(void(^)(void))sureHandel CancelAction:(void(^)(void))cancelHandel;
@end
