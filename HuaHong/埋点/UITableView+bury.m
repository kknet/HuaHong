//
//  UITableView+bury.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/17.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "UITableView+bury.h"
#import <objc/runtime.h>

@implementation UITableView (bury)

+ (void)load
{
     [self swizzleInstanceMethod:@selector(setDelegate:) swizzledSEL:@selector(swizzled_setDelegate:)];
}

- (void)swizzled_setDelegate:(id<UITableViewDelegate>)delegate
{
   
    if ([self.key isEqualToString:@"123"]) {
        
        NSLog(@"TableView被拦截");
        return;
    }
    
    [self swizzled_setDelegate:delegate];
}

@end
