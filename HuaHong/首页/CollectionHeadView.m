//
//  CollectionHeadView.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/29.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "CollectionHeadView.h"

@implementation CollectionHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        /*
         *  图片的添加
         */
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(16, 11, 18, 18)];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        _iconImage.layer.cornerRadius = 4;
        _iconImage.clipsToBounds = YES;
        [self addSubview:_iconImage];
        
        _headText = [[UILabel alloc]initWithFrame:CGRectMake(42, 0, self.width-42, 40)];
        _headText.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_headText];
        
    }
    return self;
}

@end
