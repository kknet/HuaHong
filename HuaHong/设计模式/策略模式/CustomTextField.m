//
//  CustomTextField.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (BOOL)validate {
    BOOL result = [self.inputValidate validateInputTextField:self];
    
    if (!result) {
        NSLog(@"----%@", self.inputValidate.attributeInputStr);
    } else {
        NSLog(@"----%@", self.inputValidate.attributeInputStr);
    }
    
    return result;
}

@end
