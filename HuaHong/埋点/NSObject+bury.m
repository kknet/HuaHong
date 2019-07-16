//
//  NSObject+bury.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/16.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "NSObject+bury.h"
#import <objc/runtime.h>

@implementation NSObject (bury)

- (NSString *)key
{
   return  objc_getAssociatedObject(self, @selector(key));
}

- (void)setKey:(NSString *)key
{
    objc_setAssociatedObject(self, @selector(key), key, OBJC_ASSOCIATION_COPY);
}
@end
