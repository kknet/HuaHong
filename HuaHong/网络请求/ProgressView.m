//
//  ProgressView.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

-(void)setProgress:(float)progress
{
    
    _progress = progress;
    [self setNeedsDisplay];
    
    [self setTitle:[NSString stringWithFormat:@"%.2f%%",_progress*100] forState:UIControlStateNormal];

}

- (void)drawRect:(CGRect)rect
{
    
    CGSize size = rect.size;
    CGPoint center = CGPointMake(size.width*0.5, size.height*0.5);
//    CGFloat radius = (size.width<size.height)? size.width*0.5 : size.height*0.5;
//    radius -= 5;
    CGFloat radius = MIN(center.x, center.y) - 5;

    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + self.progress*2*M_PI;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];

    [path setLineCapStyle:kCGLineCapRound];
//    [path setLineJoinStyle:kCGLineJoinRound];
    
    [path setLineWidth:10.0];
    [[UIColor orangeColor]set];
    [path stroke];
    
}


@end
