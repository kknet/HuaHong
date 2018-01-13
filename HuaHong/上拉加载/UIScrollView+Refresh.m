//
//  UIScrollView+Refresh.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>

static const char *key = "key";
@implementation UIScrollView (Refresh)

-(PullUpRefreshView *)refreshView
{
  PullUpRefreshView * refreshView = objc_getAssociatedObject(self, key);
    if (refreshView == nil) {
        refreshView = [[PullUpRefreshView alloc]init];
        [self addSubview:refreshView];
        
        self.refreshView = refreshView;
    }
    
    return refreshView;
}

-(void)setRefreshView:(PullUpRefreshView *)refreshView
{
    objc_setAssociatedObject(self, key, refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
