//
//  UIButton+space.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleTop,   //image在上
    ButtonEdgeInsetsStyleLeft,  //image在左
    ButtonEdgeInsetsStyleBottom,//image在下
    ButtonEdgeInsetsStyleRight  //image在右
};
@interface UIButton (space)

- (void)layoutButtonEdgeInsetsWithStyle:(ButtonEdgeInsetsStyle)style Space:(CGFloat)space;
@end


