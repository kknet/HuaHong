//
//  UIViewController+Alert.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

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
+ (void)showAlertWhithTarget:(UIViewController *)target Title:(NSString *)title Message:(NSString *)message SureTitle:(NSString *)sureTitle CancelTitle:(NSString *)cancelTitle SureAction:(void(^)(void))sureHandel CancelAction:(void(^)(void))cancelHandel
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (sureTitle)
    {
        [alert addAction:[UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureHandel) {
                sureHandel();
            }
            
        }]];
    }
    
    if (cancelTitle)
    {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelHandel) {
                cancelHandel();
            }
            
            
        }]];
    }
    
    alert.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [target presentViewController:alert animated:YES completion:nil];
    
//    [UIAlertView alloc]initWithTitle:<#(nullable NSString *)#> message:<#(nullable NSString *)#> delegate:<#(nullable id)#> cancelButtonTitle:<#(nullable NSString *)#> otherButtonTitles:<#(nullable NSString *), ...#>, nil
}

@end
