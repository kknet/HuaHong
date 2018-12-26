//
//  UITextView+PlaceHolder.h
//  HuaHong
//
//  Created by 华宏 on 2018/12/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (PlaceHolder)

@property (nonatomic, copy) IBInspectable NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@end

