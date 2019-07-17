//
//  UIGestureRecognizer+bury.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/16.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "UIGestureRecognizer+bury.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (bury)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod([self class], @selector(addTarget:action:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzled_addTarget:action:));
    if (!originalMethod || !swizzledMethod) {
        return;
    }
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)swizzled_addTarget:(id)target action:(SEL)action
{
    if ([self.key isEqualToString:@"123"]) {
        
        NSLog(@"手势被拦截");
        return;
    }
    
     [self swizzled_addTarget:target action:action];
}
@end
