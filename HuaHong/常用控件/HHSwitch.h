//
//  HHSwitch.h
//  HuaHong
//
//  Created by 华宏 on 2018/5/23.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSwitch : UIControl
@property (nonatomic, assign, getter = isOn) BOOL on;

@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *thumbTintColor;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSString *onText;
@property (nonatomic, strong) NSString *offText;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end
