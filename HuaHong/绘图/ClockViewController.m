//
//  ClockViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/29.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "ClockViewController.h"

@interface ClockViewController ()
@property (strong, nonatomic) CALayer *second;

@end

@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建表盘
    CALayer *clock = [[CALayer alloc]init];
    clock.bounds = CGRectMake(0, 0, 200, 200);
    clock.position = self.view.center;
    clock.contents = (__bridge id)[UIImage imageNamed:@"clock"].CGImage;
    clock.cornerRadius = clock.bounds.size.height*0.5;
    clock.masksToBounds = YES;
    
    //创建表针
    CALayer *second = [[CALayer alloc]init];
    second.bounds = CGRectMake(0, 0, 2, clock.bounds.size.height*0.4);
    second.position = clock.position;
    second.backgroundColor = [UIColor redColor].CGColor;
    //锚点
    second.anchorPoint = CGPointMake(0.5, 0.8);
    
    [self.view.layer addSublayer:clock];
    [self.view.layer addSublayer:second];
    
    self.second = second;
    
    //计时器
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeChange)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self timeChange];
}


-(void)timeChange
{
    //一秒旋转的角度
    CGFloat angle = 2 * M_PI / 60;
    
    NSDate *date = [NSDate date];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"ss"];
    //    CGFloat time = [[formatter stringFromDate:date] floatValue];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    CGFloat time = [calendar component:NSCalendarUnitSecond fromDate:date];
    
    self.second.affineTransform = CGAffineTransformMakeRotation(time*angle);
}
@end
