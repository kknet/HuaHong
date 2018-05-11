//
//  NumberValidate.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "NumberValidate.h"

@implementation NumberValidate

- (BOOL)validateInputTextField:(UITextField *)textField {
    if(textField.text.length == 0) {
        self.attributeInputStr = @"数值空的";
        return self.attributeInputStr;
    }
    
    // 正则验证
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]*$" options:NSRegularExpressionAnchorsMatchLines error:nil];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:[textField text] options:NSMatchingAnchored range:NSMakeRange(0, [[textField text] length])];
    
    if (numberOfMatches == 0) {
        self.attributeInputStr = @"数字,输入有问题";
    } else {
        self.attributeInputStr = @"输入正确";
    }
    return self.attributeInputStr == nil ? YES : NO;
}

@end
