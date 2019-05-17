//
//  UITextField+space.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UITextField+Extension.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UITextField (Extension)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method text = class_getInstanceMethod(self, @selector(text));
        
        //获取自己刚刚新建的方法
        Method myText = class_getInstanceMethod(self, @selector(myText));
        
        method_exchangeImplementations(text, myText);
        
        
    });
}

- (NSString *)myText
{
    return [self.myText stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - UITextFieldDelegate
#define myDotNumbers     @"0123456789.\n"
#define myNumbers        @"0123456789\n"

/**
 数字输入限制

 @param range range
 @param string string
 @param integerlimit 整数限制位数
 @param decimalLimit 小数限制位数
 @return 能否输入
 */
-(BOOL)hh_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string Integerlimit:(NSUInteger)integerlimit DecimalLimit:(NSUInteger)decimalLimit
{
    NSCharacterSet *cs;
    NSUInteger dotLocation = [self.text rangeOfString:@"."].location;
    
    if (dotLocation == NSNotFound && range.location != 0)
    {
        if (range.location == integerlimit && ![string isEqualToString:@"."])
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
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    //    if (textField.text.length >= 11) {
    //        return NO;
    //    }
    
//    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    NSString *emailRegex = @"^\\d{0,8}(\\.\\d{0,2})?$";
//    //        NSString *emailRegex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
//    return [emailTest evaluateWithObject:checkStr];
    
    return YES;
}

-(void)textFieldDidChange
{
    NSString * regex = @"^0+[0-9]";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.text];
    
    if (isMatch)
    {
        self.text = [self.text substringFromIndex:1];
        
    }
}

@end
