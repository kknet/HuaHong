//
//  HHAttachment.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/23.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHAttachment.h"

@implementation HHAttachment

// 图文混排时 ，指定图片的大小
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex{
    
    //lineFrag.size.height 文字高度
    return CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    
}

@end
