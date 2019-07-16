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
    Method originalMethod = class_getClassMethod(self, @selector(URLWithString:));
    Method swizzledMethod = class_getClassMethod(self, @selector(HHURLWithString:));
    if (!originalMethod || !swizzledMethod) {
        return;
    }
    method_exchangeImplementations(originalMethod, swizzledMethod);

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
