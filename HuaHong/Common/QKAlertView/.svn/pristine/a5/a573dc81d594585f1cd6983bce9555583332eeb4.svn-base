//
//  QKAlertView.h
//  QK365
//
//  Created by wangxiaoli on 2017/11/29.
//  Copyright © 2017年 qk365. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum :NSUInteger {
    QKAlertNone,
    QKAlertOne,
    QKAlertTwo
}QKAlertType;

@interface QKAlertView : UIView

@property (nonatomic, strong, readonly) UIView *alertView;

+ (instancetype)sharedAlertView;


/**
 弹出框

 @param title 弹出框标题，空值传nil
 @param message 弹出框详情信息，空值传nil
 @param callback 回调处理事件
 @param otherBtnTitles btn标题，传一个标题，弹出框只有一个btn，依此类推
 */
- (void)alertWithTitle:(NSString *)title
                      message:(NSString *)message
              buttonClickback:(void(^)(QKAlertView *alertView,NSInteger buttonIndex))callback
                 buttonTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION;

/**
 弹出框
 
 @param title 弹出框标题，空值传nil
 @param message 弹出框详情信息：若是倒计时如：5s倒计时，空值传nil
 @param callback 回调处理事件
 @param countDownTime 倒计时具体数值：5
 @param otherBtnTitles btn标题，传一个标题，弹出框只有一个btn，依此类推
 */
- (void)alertWithTitle:(NSString *)title
                      message:(NSString *)message
              buttonClickback:(void(^)(QKAlertView *alertView,NSInteger buttonIndex))callback
                    countDown:(NSInteger)countDownTime buttonTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION;

- (void)show;
@end
