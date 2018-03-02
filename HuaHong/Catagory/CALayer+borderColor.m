//
//  CALayer+borderColor.m
//  TheHousing
//
//  Created by 华宏 on 2017/12/12.
//  Copyright © 2017年 com.qk365. All rights reserved.
//

#import "CALayer+borderColor.h"

@implementation CALayer (borderColor)

-(void)setBorderColorWithUIColor:(UIColor *)borderColorWithUIColor
{
    self.borderColor = borderColorWithUIColor.CGColor;
}
@end
