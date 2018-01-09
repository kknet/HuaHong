//
//  ScanView.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "ScanView.h"

static NSTimeInterval kQrLineanimateDuration = 0.02;
@implementation ScanView
{
    UIImageView *qrLine;
    CGFloat qrLineY;
}

-(void)initQRLine
{
    qrLine = [[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-self.scanAreaSize.width)/2, (self.bounds.size.height-self.scanAreaSize.height)/2, self.scanAreaSize.width, 2)];
    qrLine.image = [UIImage imageNamed:@"scanline"];
    qrLine.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:qrLine];
    qrLineY = qrLine.frame.origin.y;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!qrLine)
    {
        [self initQRLine];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kQrLineanimateDuration target:self selector:@selector(show) userInfo:nil repeats:YES];
        [timer fire];
    }
}

-(void)show
{
    [UIView animateWithDuration:kQrLineanimateDuration animations:^{
        CGRect rect = qrLine.frame;
        rect.origin.y = qrLineY;
        qrLine.frame = rect;
    } completion:^(BOOL finished) {
        CGFloat maxBorder = self.bounds.size.height/2+self.scanAreaSize.height/2-4;
        if (qrLineY > maxBorder) {
            qrLineY = self.bounds.size.height/2-self.scanAreaSize.height/2;
        }
        
        qrLineY++;
    }];
}

- (void)drawRect:(CGRect)rect
{
    CGRect screenDrawRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    //中间清空的矩形框
    CGRect clearRect = CGRectMake(screenDrawRect.size.width/2-self.scanAreaSize.width/2, screenDrawRect.size.height/2-self.scanAreaSize.height/2, self.scanAreaSize.width, self.scanAreaSize.height);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    [self addScreenFillRect:contextRef rect:screenDrawRect];
    [self addCenterClearRect:clearRect ContextRef:contextRef];
    [self addWhiteRect:clearRect ContextRef:contextRef];
    [self addCornerLineWithContext:contextRef rect:clearRect];
}

-(void)addScreenFillRect:(CGContextRef)contextRef rect:(CGRect)rect
{
    CGContextSetRGBFillColor(contextRef, 40/255.0, 40/255.0, 40/255.0, 0.5);
    CGContextFillRect(contextRef, rect);
}

-(void)addCenterClearRect:(CGRect)rect ContextRef:(CGContextRef)contextRef
{
    CGContextClearRect(contextRef, rect);
}

-(void)addWhiteRect:(CGRect)rect ContextRef:(CGContextRef)contextRef
{
    CGContextStrokeRect(contextRef, rect);
    CGContextSetRGBStrokeColor(contextRef, 1, 1, 1, 1);
    CGContextSetLineWidth(contextRef, 0.8);
    CGContextAddRect(contextRef, rect);
    CGContextStrokePath(contextRef);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    CGFloat LineWidth = 5.0;
    CGFloat LineHeight = 15.0;
    //画四个边角
    CGContextSetLineWidth(ctx, LineWidth);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+LineWidth/2, rect.origin.y),
        CGPointMake(rect.origin.x+LineWidth/2 , rect.origin.y + LineHeight)
    };
    
    CGPoint poinsTopLeftB[] = {
        CGPointMake(rect.origin.x, rect.origin.y+LineWidth/2),
        CGPointMake(rect.origin.x + LineHeight, rect.origin.y+LineWidth/2)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {
        CGPointMake(rect.origin.x+LineWidth/2, rect.origin.y + rect.size.height - LineHeight),
        CGPointMake(rect.origin.x+LineWidth/2,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {
        CGPointMake(rect.origin.x , rect.origin.y + rect.size.height-LineWidth/2) ,
        CGPointMake(rect.origin.x +LineHeight, rect.origin.y + rect.size.height-LineWidth/2)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - LineHeight, rect.origin.y+LineWidth/2),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y+LineWidth/2)};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-LineWidth/2, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-LineWidth/2,rect.origin.y + LineHeight )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    //右下角
    CGPoint poinsBottomRightA[] = {
        CGPointMake(rect.origin.x+ rect.size.width-LineWidth/2 , rect.origin.y+rect.size.height+ -LineHeight),
        CGPointMake(rect.origin.x + rect.size.width-LineWidth/2,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {
        CGPointMake(rect.origin.x+ rect.size.width - LineHeight , rect.origin.y + rect.size.height-LineWidth/2),
        CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - LineWidth/2)};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

@end
