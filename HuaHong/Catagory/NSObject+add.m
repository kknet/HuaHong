//
//  NSObject+add.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/16.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "NSObject+add.h"
#import <objc/runtime.h>

@implementation NSObject (add)

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
    

//    要先尝试添加原 selector 是为了做一层保护，因为如果这个类没有实现原始方法"originalSel" ，但其父类实现了，那 class_getInstanceMethod 会返回父类的方法。这样 method_exchangeImplementations 替换的是父类的那个方法，这当然不是你想要的。所以我们先尝试添加 originalSel ，如果已经存在，再用 method_exchangeImplementations 把原方法的实现跟新的方法实现给交换掉。
    
//    class_addMethod先判断了子类中是否有method方法
//    如果有，则添加失败，直接进行交换
//    如果没有，则添加成功，将swizzledMethod的IMP赋值给method这个Selector，然后在将method的IMP（其实是父类中的实现）赋值给swizzledMethod这个Selector
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
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
