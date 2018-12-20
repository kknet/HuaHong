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
 @param otherTitles  其它按钮文字
 @param cancelTitle 取消按钮文字
 @param clickHandel 点击事件
 */
+ (void)showAlertWhithTarget:(UIViewController *)target Title:(NSString *)title Message:(NSString *)message ClickAction:(void(^)(UIAlertController *alertCtrl,NSInteger buttonIndex))clickHandel CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString *)otherTitles,...NS_REQUIRES_NIL_TERMINATION
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableArray *otherTitleArrM = [NSMutableArray array];
    
    va_list argList;
    if(otherTitles)
    {
        [otherTitleArrM addObject:otherTitles];
        va_start(argList, otherTitles);
        id temp;
        while((temp = va_arg(argList, id))){
            [otherTitleArrM addObject:temp];
        }
    }
    va_end(argList);
    
    
    __weak typeof(alertCtrl) weakAlertCtrl = alertCtrl;

    if (cancelTitle)
    {
        [alertCtrl addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (clickHandel) {
                clickHandel(weakAlertCtrl,0);
            }
            
            
        }]];
    }
    

    for (NSString *otherTitle in otherTitleArrM) {
        [alertCtrl addAction:[UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clickHandel) {
                clickHandel(weakAlertCtrl,[otherTitleArrM indexOfObject:otherTitle]+1);
            }
            
        }]];
    }
    
    alertCtrl.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [target presentViewController:alertCtrl animated:YES completion:nil];
    
}

@end
