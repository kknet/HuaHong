//
//  TestViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TestViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "AppDelegate+Notification.h"

@interface TestViewController()
@property (nonatomic,strong) UILocalNotification *localNotification;
@end

@implementation TestViewController
{
//    dispatch_source_t _timer;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"测试";
    
        
//    NSThread *t = [[NSThread alloc]initWithTarget:self selector:@selector(timeAction:) object:@"name"];
//    [t start];
    

    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
//    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    [delegate setLocalNotification];
//
//    self.localNotification = [[UILocalNotification alloc] init];
    runtimeViewController *vc = [runtimeViewController new];
    [vc eat:@"123"];
    
}

-(void)timeAction:(NSString *)name
{
    //多线程互斥锁
    @synchronized(self)
    {
        
    }
    
    self.view.backgroundColor =         [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
}
@end
