//
//  HHProxy.m
//  HuaHong
//
//  Created by 华宏 on 2018/12/10.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHProxy.h"

@implementation HHProxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}
@end
