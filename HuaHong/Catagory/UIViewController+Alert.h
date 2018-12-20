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
 @param otherTitles  其它按钮文字
 @param cancelTitle 取消按钮文字
 @param clickHandel 点击事件
 */
/** 不存在内存泄漏问题，不用使用weakSelf */
+ (void)showAlertWhithTarget:(UIViewController *)target Title:(NSString *)title Message:(NSString *)message ClickAction:(void(^)(UIAlertController *alertCtrl,NSInteger buttonIndex))clickHandel CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString *)otherTitles,...NS_REQUIRES_NIL_TERMINATION;

@end
