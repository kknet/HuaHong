//
//  DrawBoardView.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/5.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "DrawBoardView.h"
#import "HHBezierPath.h"

@interface DrawBoardView()
@property (nonatomic,strong) NSMutableArray *pathArr;
@end
@implementation DrawBoardView

-(NSMutableArray *)pathArr
{
    if (_pathArr == nil) {
        _pathArr = [NSMutableArray array];
    }
    
    return _pathArr;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:touch.view];
    
    HHBezierPath *path = [HHBezierPath bezierPath];
    [path moveToPoint:startPoint];
    path.lineWidth = self.lineWidth;
    path.lineColor = self.lineColor;
    
    [self.pathArr addObject:path];
    
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:touch.view];
    
    HHBezierPath *path = [self.pathArr lastObject];
    [path addLineToPoint:movePoint];
    
    [self setNeedsDisplay];

}
- (void)drawRect:(CGRect)rect {
    
    for (HHBezierPath *path in self.pathArr) {
        
        path.lineJoinStyle = kCGLineJoinRound;
        path.lineCapStyle = kCGLineCapRound;
        [path.lineColor set];
        [path stroke];
    }
}

-(void)clear
{
    [self.pathArr removeAllObjects];
    
    [self setNeedsDisplay];
}
-(void)back
{
    [self.pathArr removeLastObject];
    
    [self setNeedsDisplay];

}
-(void)xiangpi
{
    self.lineColor = self.backgroundColor;
}
@end
