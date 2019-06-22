//
//  UITextField+Limit.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UITextField+Limit.h"

@implementation UITextField (Limit)


#pragma mark - UITextFieldDelegate
#define myDotNumbers     @"0123456789.\n"
#define myNumbers        @"0123456789\n"

/**
 数字输入限制
 
 @param range range
 @param string string
 @param intLimit 整数限制位数
 @param decimalLimit 小数限制位数
 @return 能否输入
 */
-(BOOL)hh_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string IntLimit:(NSUInteger)intLimit DecimalLimit:(NSUInteger)decimalLimit
{
    NSCharacterSet *cs;
    NSUInteger dotLocation = [self.text rangeOfString:@"."].location;
    
    if (dotLocation == NSNotFound && range.location != 0)
    {
        if (range.location == intLimit && ![string isEqualToString:@"."])
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"."]invertedSet];
        }else
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
            
        }
    }else
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
    }
    NSString *filter = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    if (![filter isEqualToString:string])
    {
        return NO;
    }
    
    if (dotLocation != NSNotFound && range.location > dotLocation+decimalLimit) {
        return NO;
    }
    
    
    if ([self.text isEqualToString:@"0"] && ![string isEqualToString:@"."]) {
        self.text = string;
        return NO;
    }
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    
    
    return YES;
}


/**
 正则表达式限制数字输入
 
 @param range range
 @param string string
 @param intLimit 整数限制位数
 @param decimalLimit 小数限制位数
 @return 能否输入
 */
-(BOOL)regex_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string IntLimit:(NSUInteger)intLimit DecimalLimit:(NSUInteger)decimalLimit
{
    if ([self.text hasPrefix:@"0"] && ![string isEqualToString:@"."]) {
        self.text = string;
        return NO;
    }
    
    
    NSString *checkStr = [self.text stringByReplacingCharactersInRange:range withString:string];
    NSString *regex = [NSString stringWithFormat:@"^\\d{0,%lu}(\\.\\d{0,%lu})?$",(unsigned long)intLimit,(unsigned long)decimalLimit];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    return [predicate evaluateWithObject:checkStr];
}

/**
 限制手机号输入
 
 @param range range
 @param string string
 @return 能否输入
 */
-(BOOL)checkPhoneNumber_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSInteger length = textField.text.length - range.length + string.length;
//    return (length <= 11);
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    
    NSString *checkStr = [self.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![checkStr hasPrefix:@"1"]) {
        self.text = nil;
      return NO;
    }
    
    if (self.text.length >= 11) {
        return NO;
    }
 
    return YES;
}

@end
