//
//  UIControl+bury.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/16.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "UIControl+bury.h"
#import <objc/runtime.h>

@implementation UIControl (bury)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(swizzled_sendAction:to:forEvent:));
    if (!originalMethod || !swizzledMethod) {
        return;
    }
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)swizzled_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event;
{
    if ([self.key isEqualToString:@"123"]) {
        
        NSLog(@"UIControl方法被拦截");
        return;
    }
    
    
    [self swizzled_sendAction:action to:target forEvent:event];
}
@end
