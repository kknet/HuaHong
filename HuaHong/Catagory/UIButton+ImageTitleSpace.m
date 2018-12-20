//
//  UIButton+ImageTitleSpace.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UIButton+ImageTitleSpace.h"

@implementation UIButton (ImageTitleSpace)

- (void)layoutButtonEdgeInsetsWithStyle:(ButtonEdgeInsetsStyle)style Space:(CGFloat)space
{
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeiht = self.imageView.image.size.height;
    
    /** 未发现差别 */
    CGFloat titleWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;
//    CGFloat titleWidth1 = self.titleLabel.size.width;
//    CGFloat titleHeight2 = self.titleLabel.intrinsicContentSize.height;

    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleInsets = UIEdgeInsetsZero;

    switch (style) {
        case ButtonEdgeInsetsStyleTop:
        {
            imageInsets = UIEdgeInsetsMake(-(imageHeiht+space)/2.0, titleWidth*0.5, (imageHeiht+space)/2.0, -titleWidth*0.5);
            titleInsets = UIEdgeInsetsMake((titleHeight+space)/2.0, -imageWidth*0.5, -(titleHeight+space)/2.0, imageWidth*0.5);
        }
            break;
        
        case ButtonEdgeInsetsStyleBottom:
        {
            imageInsets = UIEdgeInsetsMake((imageHeiht+space)/2.0, titleWidth*0.5, -(imageHeiht+space)/2.0, -titleWidth*0.5);
            titleInsets = UIEdgeInsetsMake(-(titleHeight+space/2.0), -imageWidth*0.5, (titleHeight+space/2.0),imageWidth*0.5);
        }
            break;
        case ButtonEdgeInsetsStyleLeft:
        {
            imageInsets = UIEdgeInsetsMake(0, -space*0.5, 0, space*0.5);
            titleInsets = UIEdgeInsetsMake(0, space*0.5, 0, -space*0.5);
        }
            break;
        case ButtonEdgeInsetsStyleRight:
        {
            imageInsets = UIEdgeInsetsMake(0, (titleWidth+space*0.5), 0, -(titleWidth+space*0.5));
            titleInsets = UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0, (imageWidth+space*0.5));
        }
            break;
            
        default:
            break;
    }
    
    [self setTitleEdgeInsets:titleInsets];
    [self setImageEdgeInsets:imageInsets];
}
@end
