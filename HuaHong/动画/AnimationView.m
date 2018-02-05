//
//  AnimationView.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/31.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:100 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [[UIColor orangeColor]set];
    [path stroke];
}


@end
