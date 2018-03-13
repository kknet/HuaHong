//
//  NSURL+hook.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "NSURL+hook.h"
#import <objc/runtime.h>

@implementation NSURL (hook)

+(void)load
{
    Method URLWithStr = class_getClassMethod(self, @selector(URLWithString:));
    Method HHURLWithStr = class_getClassMethod(self, @selector(HHURLWithString:));
    method_exchangeImplementations(URLWithStr, HHURLWithStr);

}
+(instancetype)HHURLWithString:(NSString *)string
{
    NSURL *url = [NSURL HHURLWithString:string];
    if (url == nil) {
        NSLog(@"------------URL == nil------------");
    }
    
    return url;
}
@end
