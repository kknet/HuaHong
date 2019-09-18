//
//  NSObject+swizzle.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/16.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "NSObject+swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (swizzle)

- (NSString *)key
{
   return  objc_getAssociatedObject(self, @selector(key));
}

- (void)setKey:(NSString *)key
{
    objc_setAssociatedObject(self, @selector(key), key, OBJC_ASSOCIATION_COPY);
}

+ (void)swizzleInstanceMethod:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    if (!originalMethod || !swizzledMethod) {
        return;
    }
    

    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
//        class_replaceMethod(class,
//                            swizzledSEL,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
        class_replaceMethod(class,
                            originalSEL,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


+ (void)swizzleClassMethod:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL
{
    Class class = object_getClass(self);
    Method originalMethod = class_getClassMethod(class, originalSEL);
    Method swizzledMethod = class_getClassMethod(class, swizzledSEL);
    
    if (!originalMethod || !swizzledMethod) { return ; }
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
}

@end
