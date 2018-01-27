//
//  DrawView.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/23.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView
{
    CGPoint centerPoint;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
//    [self setNeedsDisplayInRect:<#(CGRect)#>]
}

- (void)drawRect:(CGRect)rect
{
    centerPoint = CGPointMake(rect.size.width*0.5, rect.size.height*0.5);

//    [self line_OC];
//    [self rectangle];
//    [self oval];
//    [self circular];
    
//    [self pieChart];
//    [self barChart];
    
//    [self drawText];
//    [self drawImage];
    [self clicpImage];
}

#pragma mark - 柱状图
-(void)barChart
{
    NSArray *array = @[@0.3,@0.5,@0.4,@0.8];

    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 30;
    CGFloat h = 0;
    
    for (int i=0; i<array.count; i++) {
        x = i * 2 * w;
        h = self.bounds.size.height * [array[i] floatValue];
        y = self.bounds.size.height - h;

        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
        [[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0] set];
        [path fill];
    }
}
#pragma mark - 饼图
-(void)pieChart
{
    NSArray *array = @[@0.3,@0.2,@0.4,@0.1];
    CGFloat start = 0,end = 0;
    CGFloat margin = 30;//边距
    CGFloat radius = (MIN(self.bounds.size.width, self.bounds.size.height)-margin*2)*0.5;
    
    for (int i=0; i<array.count; i++) {
        
        end = 2*M_PI* [array[i] floatValue] + start;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:start endAngle:end clockwise:YES];
        [path addLineToPoint:centerPoint];
//        [path closePath];
        
        [[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0] setFill];
        
        [path fill];
        
        start = end;
    }
    
    
}

#pragma mark - 圆
-(void)circular
{
    /**
     * startAngle endAngle 起始位置/结束位置 默认从3点开始
     * clockwise:YES为顺时针
     */
   UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:100 startAngle:0 endAngle:M_PI + M_PI_2 clockwise:YES];
    [path setLineWidth:5];
    [path stroke];
    
    //clockwise:0为顺时针 默认从3点开始
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddArc(ctx, 150, 150, 100, 0, M_PI/3 , 1);
//    CGContextStrokePath(ctx);
}

#pragma mark - 椭圆
-(void)oval
{
    
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 200)] stroke];
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 100, 200));
//    CGContextStrokePath(ctx);
    
}

#pragma mark - 矩形
-(void)rectangle
{
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 100, 100)];
//    [path stroke];
    
//    [[UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 100, 100)] stroke];
    
    //圆角矩形
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 200, 100, 100) cornerRadius:10] stroke];
}

#pragma mark - 画线
-(void)line_OC
{
    //OC
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
    [path addLineToPoint:CGPointMake(100, 100)];
    [path addLineToPoint:CGPointMake(150, 50)];
    [path closePath];
    
    //设置连接点样式
//    [path setLineJoinStyle:kCGLineJoinBevel];
    
    //设置两端样式
//    [path setLineCapStyle:kCGLineCapSquare];
    
    [[UIColor orangeColor] set];//同时设置填充和描边的颜色
    [path fill];
    
    path.usesEvenOddFillRule = YES;//是否使用奇偶填充规则
}
-(void)line_C_OC2
{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //拼接路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 50, 50);
    CGPathAddLineToPoint(path, NULL, 100, 100);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:path];
    [bezierPath addLineToPoint:CGPointMake(150, 50)];
    
    //把路径添加到上下文中
    CGContextAddPath(ctx, bezierPath.CGPath);
    
    //渲染
    CGContextStrokePath(ctx);
    
    // 释放
    CFRelease(path);
    
}
-(void)line_C_OC1
{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //拼接路径 OC
    UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
    [bezierPath moveToPoint:CGPointMake(50, 50)];
    [bezierPath addLineToPoint:CGPointMake(100, 100)];
    
    //把路径添加到上下文中
    CGContextAddPath(ctx, bezierPath.CGPath);
    
    //渲染
    CGContextStrokePath(ctx);
}
-(void)line_C2
{
   //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //拼接路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 50, 50);
    CGPathAddLineToPoint(path, NULL, 100, 100);
    
    //把路径添加到上下文中
    CGContextAddPath(ctx, path);
    
    //渲染
    CGContextStrokePath(ctx);
    
    // 释放
    CFRelease(path);
}
-(void)line_C1
{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //矩阵操作
    //旋转
    CGContextRotateCTM(ctx, M_PI_4);
    
    //缩放
    CGContextScaleCTM(ctx, 2, 2);
    
    //平移
    CGContextTranslateCTM(ctx, 30, 30);
    
    //拼接路径，同时把路径添加到上下文中
    CGContextMoveToPoint(ctx, 30, 30);
    CGContextAddLineToPoint(ctx, 100, 100);
    CGContextAddLineToPoint(ctx, 150, 50);
    CGContextClosePath(ctx);//关闭路径

    [[UIColor orangeColor] setStroke];

    //渲染
    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
    
    //奇偶填充：奇数填充，偶数不填充
    CGContextDrawPath(ctx, kCGPathEOFill); //同上等效
}

#pragma mark - 绘制文字
-(void)drawText
{
    NSString *string = @"绘制文字";
    
    //从某一点开始绘制
//    [string drawAtPoint:CGPointZero withAttributes:nil];
    
    //从某一区域开始绘制
    [string drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30]}];
}

#pragma mark - 绘制图片
-(void)drawImage
{
    UIImage *image = [UIImage imageNamed:@"MyRoom"];

    //从某一点开始绘制
    [image drawAtPoint:CGPointZero];
    
    //在某一区域开始绘制 （拉伸）
    [image drawInRect:self.bounds];
    
    //平铺
    [image drawAsPatternInRect:self.bounds];
}

#pragma mark - 绘制图片
-(void)clicpImage
{
    UIImage *image = [UIImage imageNamed:@"MyRoom"];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘制裁剪区域
    CGContextAddArc(ctx, centerPoint.x, centerPoint.y, (self.bounds.size.width-30*2)/2, 0, 2*M_PI, 1);
    
    //裁剪
    CGContextClip(ctx);
    
    //在某一区域开始绘制 （拉伸）
    [image drawInRect:self.bounds];
}
@end
