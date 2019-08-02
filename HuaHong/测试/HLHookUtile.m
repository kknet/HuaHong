//
//  HLHookUtile.m
//  HuaHong
//
//  Created by qk-huahong on 2019/8/2.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "HLHookUtile.h"
#import <objc/runtime.h>

@implementation HLHookUtile


+(void)hookClass:(Class)cls andOriginalSEL:(SEL)originalSEL andSwizzledSEL:(SEL)swizzledSEL
{
    Method originalMethod = class_getInstanceMethod(cls, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSEL);
    //添加hook  : 为该类添加新方法
    BOOL isAdd = class_addMethod(cls, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isAdd) {
        //如果成功  说明类中不存在这个方法的实现需要将被交换方法的实现替换到这个并不存在的实现
        class_replaceMethod(cls, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    } else {
        //交换实现  存在这个方法的实现只要交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
