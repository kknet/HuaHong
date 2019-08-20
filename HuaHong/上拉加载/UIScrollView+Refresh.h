//
//  UIScrollView+Refresh.h
//  HuaHong
//
//  Created by 华宏 on 2018/1/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullUpRefreshView.h"

@interface UIScrollView (Refresh)

@property (nonatomic, strong) PullUpRefreshView *refreshView;
@end
