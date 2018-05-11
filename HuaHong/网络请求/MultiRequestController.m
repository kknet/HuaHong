//
//  MultiRequestController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/27.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "MultiRequestController.h"

@interface MultiRequestController ()

@end

@implementation MultiRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多网络请求";
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self request3];
}

//无序请求，全部完成再执行下一步
- (void)request1
{
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    dispatch_group_t downLoadGroup = dispatch_group_create();
    
    for (int i=0; i<10; i++) {
        
        dispatch_group_enter(downLoadGroup);
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
                 NSLog(@"%d---%d",i,i);
            dispatch_group_leave(downLoadGroup);
        }];
        
        [task resume];
    }
    
    
    dispatch_group_notify(downLoadGroup, dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
}

//无序请求，全部完成再执行下一步
- (void)request2
{
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
   __block NSInteger count = 0;
    for (int i=0; i<10; i++) {
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"%d---%d",i,i);
            count++;
            if (count ==10) {
                dispatch_semaphore_signal(sema);
                count = 0;
            }
            
        }];
        
        [task resume];
        
    }
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
    
}

//按顺序请求，全部完成再执行下一步
- (void)request3
{
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    for (int i=0; i<10; i++) {
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
             NSLog(@"%d---%d",i,i);
            
            dispatch_semaphore_signal(sema);
            
        }] resume];
        
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
    
    
    
}


@end
