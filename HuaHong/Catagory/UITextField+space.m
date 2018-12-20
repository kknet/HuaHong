//
//  UITextField+space.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UITextField+space.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UITextField (space)

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
@end
