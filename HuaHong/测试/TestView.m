//
//  TestView.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/28.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "TestView.h"

@implementation TestView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor cyanColor];

        NSLog(@"\ninitWithCoder");

    }

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"\nawakeFromNib");

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        NSLog(@"\ninitWithFrame");
    }
    
    return self;
}
- (void)drawRect:(CGRect)rect
{
    NSString *str = @"此处手写签名: 正楷, 工整书写";

    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context,  199/255.0, 199/255.0,199/255.0, 1.0);//设置填充颜色
    [str drawInRect:CGRectMake((rect.size.width -200)/2, (rect.size.height -20)/3-5,200, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
   
}


- (void)renderWithModel:(id)model
{
    NSLog(@"renderWithModel");
}
@end
