//
//  NetworkTools.m
//  HuaHong
//
//  Created by 华宏 on 2018/10/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

/*
 如果需要立即执行闭包 就直接执行闭包
 如果不需要立即执行闭包  等要用的时候再执行闭包
 使用 一个属性 将 传递的闭包记录起来  等需要的时候 执行闭包
 
 */

#import "NetworkTools.h"

@interface NetworkTools ()

@property(nonatomic,copy)void(^finishedCallBack)(NSString *);

@end

@implementation NetworkTools

-(void)loadData:(void (^)(NSString *))finished {
    
    //记录闭包
    self.finishedCallBack = finished;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //执行网络请求的耗时操作
        
        //在主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //执行闭包
            //finished(@"hello");
            [self working];
            
        });
    });
}

-(void)working {
    
    //需要判断闭包是否为空
    if (self.finishedCallBack) {
        
        self.finishedCallBack(@"Hello World");
    }
}


- (void)dealloc
{
    NSLog(@"tools 888");
}

@end
