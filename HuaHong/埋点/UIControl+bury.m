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
    [self swizzleInstanceMethod:@selector(sendAction:to:forEvent:) swizzledSEL:@selector(swizzled_sendAction:to:forEvent:)];
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
