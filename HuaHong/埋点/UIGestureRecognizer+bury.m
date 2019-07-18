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
    [self swizzleInstanceMethod:@selector(addTarget:action:) swizzledSEL:@selector(swizzled_addTarget:action:)];
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
