//
//  PullUpRefreshView.h
//  HuaHong
//
//  Created by 华宏 on 2018/1/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullUpRefreshView : UIView

@property (nonatomic,copy) void (^pullUpBlock)();

-(void)endloadMore;

@end
