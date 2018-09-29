//
//  MVVM_HeaderView.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVM_HeaderView.h"

@implementation MVVM_HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel * lable = [[UILabel alloc] initWithFrame:frame];
        lable.text = @"这是头部视图";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.backgroundColor = [UIColor grayColor];
        [self addSubview:lable];
    }
    return  self;
}


@end
