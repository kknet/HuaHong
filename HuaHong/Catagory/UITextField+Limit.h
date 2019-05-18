//
//  UITextField+Limit.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Limit)

/**
 数字输入限制
 
 @param range range
 @param string string
 @param intLimit 整数限制位数
 @param decimalLimit 小数限制位数
 @return 能否输入
 */
-(BOOL)hh_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string IntLimit:(NSUInteger)intLimit DecimalLimit:(NSUInteger)decimalLimit;


/**
 正则表达式限制数字输入

 @param range range
 @param string string
 @param intLimit 整数限制位数
 @param decimalLimit 小数限制位数
 @return 能否输入
 */
-(BOOL)regex_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string IntLimit:(NSUInteger)intLimit DecimalLimit:(NSUInteger)decimalLimit;

/**
 限制手机号输入
 
 @param range range
 @param string string
 @return 能否输入
 */
-(BOOL)checkPhoneNumber_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
