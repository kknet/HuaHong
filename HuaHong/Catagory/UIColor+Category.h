//
//  UIColor+Category.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/1.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert andAlpha:(CGFloat)alpha;

@end
