//
//  UITextField+space.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Extension)

- (NSString *)myText;

/**
 数字输入限制
 
 @param range range
 @param string string
 @param integerlimit 整数限制位数
 @param decimalLimit 小数限制位数
 @return 能否输入
 */
-(BOOL)hh_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string Integerlimit:(NSUInteger)integerlimit DecimalLimit:(NSUInteger)decimalLimit;
@end

NS_ASSUME_NONNULL_END
