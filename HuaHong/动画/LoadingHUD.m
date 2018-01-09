//
//  LoadingHUD.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/8.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "LoadingHUD.h"

@interface LoadingHUD()

@property (nonatomic,assign) BOOL isPlay;
@property (nonatomic,strong) CADisplayLink *disPlayLink;
@property (nonatomic,strong) UIColor *smallRoundedfillColor;
@property (nonatomic,strong) UIColor *minRoundedfileColor;
@property (nonatomic,assign) CGFloat currentProgress;

@end

@implementation LoadingHUD

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _progress = self.currentProgress = 0;
        _isPlay = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        self.disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(reloadView)];
        [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [_disPlayLink invalidate];
    }
}

-(void)reloadView
{
    if (_currentProgress >= _progress) {
        _disPlayLink.paused = YES;
        return;
    }
    
    _currentProgress += 0.01;
    [self setNeedsDisplay];
}

-(void)tapAction
{
    _isPlay = !_isPlay;
    _disPlayLink.paused = !_isPlay;
    if (_playOrSuspendHandler) {
        _playOrSuspendHandler(_isPlay);
    }
    
    [self setNeedsDisplay];
}

-(CGFloat)endAngle
{
    double integer;
    CGFloat endAngle = - M_PI_2 + M_PI *2 * modf(_currentProgress, &integer);
    return endAngle;
}

-(void)setCurrentProgress:(CGFloat)currentProgress
{
    _currentProgress = currentProgress;
//    if ((NSInteger)currentProgress % 2 == 0) {
        self.smallRoundedfillColor = [UIColor blackColor];
        self.minRoundedfileColor = [UIColor whiteColor];
//    }else{
//        self.smallRoundedfillColor = [UIColor whiteColor];
//        self.minRoundedfileColor = [UIColor blackColor];
//    }
    
}

-(void)setProgress:(CGFloat)progress
{
    if (_progress != progress) {
        _progress = progress;
        _disPlayLink.paused = NO;
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat bigRadius = width / 2 * 0.9;
    CGFloat smallRadius = width / 2 * 0.7;
    
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(width/2-bigRadius, height/2-bigRadius, bigRadius*2, bigRadius*2) cornerRadius:bigRadius];
    [bezierPath1 fill];
    
    [_smallRoundedfillColor setFill];
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(width/2-smallRadius, height/2-smallRadius, smallRadius*2, smallRadius*2) cornerRadius:smallRadius];
    [bezierPath2 fill];
    [bezierPath2 stroke];
    
    CGPoint center = CGPointMake(width/2, height/2);

    if (_isPlay)
    {
        [_minRoundedfileColor setFill];
        UIBezierPath *bezierPath3 = [UIBezierPath bezierPath];
        [bezierPath3 moveToPoint:center];
//        [bezierPath3 addLineToPoint:CGPointMake(width/2, height/2-smallRadius)];
        [bezierPath3 addArcWithCenter:center radius:smallRadius startAngle:-M_PI_2 endAngle:self.endAngle clockwise:YES];
        [bezierPath3 addLineToPoint:center];
        [bezierPath3 stroke];
        [bezierPath3 fill];
    }else
    {
        [_minRoundedfileColor setFill];
        CGFloat minimumRadius = smallRadius / 3;
        CGFloat changeAngle = self.endAngle + M_PI_2;
        CGFloat x = sin(changeAngle) * smallRadius;
        CGFloat y = cos(changeAngle) * smallRadius;
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:CGPointMake(center.x, center.y - minimumRadius)];
        [path2 addArcWithCenter:center radius:minimumRadius startAngle:- M_PI_2 endAngle:self.endAngle clockwise:YES];
        [path2 addLineToPoint:CGPointMake(center.x + x, center.y - y)];
        [path2 addArcWithCenter:center radius:smallRadius startAngle:self.endAngle endAngle:- M_PI_2 clockwise:NO];
        [path2 addLineToPoint:CGPointMake(center.x, center.y - minimumRadius)];
        [path2 stroke];
        [path2 fill];
        
        CGFloat lineWith = 5;
        CGFloat lineHeight = 10;
        CGFloat centerSpace = 3;
        UIBezierPath *path3 = [UIBezierPath bezierPath];
        path3.lineWidth = lineWith;
        [path3 moveToPoint:CGPointMake(center.x - lineWith - centerSpace, center.y - lineHeight / 2)];
        [path3 addLineToPoint:CGPointMake(path3.currentPoint.x, path3.currentPoint.y + lineHeight)];
        [path3 moveToPoint: CGPointMake(center.x + centerSpace, center.y - lineHeight / 2)];
        [path3 addLineToPoint:CGPointMake(path3.currentPoint.x, path3.currentPoint.y + lineHeight)];
        [_minRoundedfileColor setStroke];
        [path3 stroke];
    }
    
}

@end
