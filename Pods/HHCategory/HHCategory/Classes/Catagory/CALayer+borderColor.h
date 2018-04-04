//
//  CALayer+borderColor.h
//  TheHousing
//
//  Created by 华宏 on 2017/12/12.
//  Copyright © 2017年 com.qk365. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (borderColor)

@property (nonatomic,strong) UIColor *borderColorWithUIColor;

-(void)setBorderColorWithUIColor:(UIColor *)borderColorWithUIColor;

@end
