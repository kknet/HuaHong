//
//  GongNengVC.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "GongNengVC.h"
#import "TestView.h"
@interface GongNengVC ()
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation GongNengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor whiteColor];
   
    //5:0 4:0 3:800 2:200
//    NSInteger money = 4000+8500+17500+9400+1200+2500+14000;
//    NSLog(@"money:%ld",(long)money);
    
    [self setValue:[[TestView alloc]init] forKey:@"view"];
    
    

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

-(void)timerAction:(NSTimer *)timer
{
    NSLog(@"111");
}
@end

