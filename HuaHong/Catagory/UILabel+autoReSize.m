//
//  UILabel+autoReSize.m
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "UILabel+autoReSize.h"

@implementation UILabel (autoReSize)

//自动设置宽度
- (void)widthToFit
{
    self.numberOfLines = 0;
    CGSize size = [self.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    CGRect frame = self.frame;
    frame.size.width = size.width + self.alignmentRectInsets.left + self.alignmentRectInsets.right;
    
    self.frame = frame;
    
}

//自动设置高度
- (void)heightToFit
{
    self.numberOfLines = 0;
    CGSize size =  [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
     CGRect frame = self.frame;
     frame.size.height = size.height + self.alignmentRectInsets.top + self.alignmentRectInsets.bottom;
   
    self.frame = frame;
    
}


+ (CGSize)labelHeightFit:(NSDictionary *)attri width:(CGFloat)width text:(NSString *)text
{
    CGSize labelSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
    labelSize = CGSizeMake((int)labelSize.width, (int)labelSize.height+1);
    return labelSize;
}

+ (CGSize)labelWidthFit:(NSDictionary *)attri height:(CGFloat)height text:(NSString *)text {
    CGSize labelSize = [text boundingRectWithSize:CGSizeMake(375, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
    labelSize = CGSizeMake((int)labelSize.width+1, (int)labelSize.height);
    return labelSize;
}

@end
