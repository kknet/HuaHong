//
//  UILabel+autoReSize.m
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "UILabel+autoReSize.h"

@implementation UILabel (autoReSize)

-(void)autoReSizeWidthForContent:(CGFloat)maxW
{
    CGSize s = [self.text boundingRectWithSize:CGSizeMake(99999, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    CGFloat w = s.width + self.alignmentRectInsets.left + self.alignmentRectInsets.right;
    CGRect f = self.frame;
    f.size.width = w > maxW ? maxW : w;
    self.frame = f;
    
}
//这个用于宽度定死了,自动设置高度
-(void)autoResizeHeightForContent:(CGFloat)maxH
{
    CGSize s =  [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    CGFloat h = s.height + self.alignmentRectInsets.top + self.alignmentRectInsets.bottom;
    CGRect f = self.frame;
    f.size.height = h > maxH ? maxH : h;
    self.frame = f;
    
}


@end
