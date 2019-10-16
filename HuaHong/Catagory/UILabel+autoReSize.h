//
//  UILabel+autoReSize.h
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (autoReSize)

/** 使用前提：已设置好frame  */
//自动设置宽度
- (void)widthToFit;

//自动设置高度
-(void)heightToFit;

+ (CGSize)labelHeightFit:(NSDictionary *)attri width:(CGFloat)width text:(NSString *)text;

+ (CGSize)labelWidthFit:(NSDictionary *)attri height:(CGFloat)height text:(NSString *)text;

@end
