//
//  UILabel+autoReSize.h
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (autoReSize)
//这个用于高度定死了,自动设置宽度
-(void)autoReSizeWidthForContent:(CGFloat)maxW;

//这个用于宽度定死了,自动设置高度
-(void)autoResizeHeightForContent:(CGFloat)maxH;

@end
