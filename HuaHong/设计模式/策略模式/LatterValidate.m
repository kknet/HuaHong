//
//  LatterValidate.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "LatterValidate.h"

@implementation LatterValidate

- (BOOL)validateInputTextField:(UITextField *)textField {
    
    if(textField.text.length == 0) {
        self.attributeInputStr = @"数值空的";
        return self.attributeInputStr;
    }
    
    // 正则
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z]*$" options:NSRegularExpressionAnchorsMatchLines error:nil];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:[textField text] options:NSMatchingAnchored range:NSMakeRange(0, [[textField text] length])];
    
    
    if (numberOfMatches == 0) {
        self.attributeInputStr = @"字母,输入有问题";
    } else {
        self.attributeInputStr = @"输入正确";
    }
    return self.attributeInputStr == nil ? YES : NO;
}

@end
