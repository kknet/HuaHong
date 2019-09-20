//
//  CallCenterController.m
//  HuaHong
//
//  Created by 华宏 on 2019/9/20.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "CallCenterController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface CallCenterController ()
@property (nonatomic, strong) CTCallCenter *callCenter;//电话管理

@end

@implementation CallCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self monitorCall];
}

#pragma mark - 电话监听-监测来电
- (void)monitorCall
{
    
    _callCenter = [[CTCallCenter alloc]init];
    _callCenter.callEventHandler = ^(CTCall *call){
        
        if ([call.callState isEqualToString:CTCallStateIncoming]) {
            
            NSLog(@"来电");
            
        }else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            
            NSLog(@"已接通");
            
            
        }else if ([call.callState isEqualToString:CTCallStateDialing]) {
            
            NSLog(@"拨打中");
            
            
        }else if ([call.callState isEqualToString:CTCallStateDisconnected]) {
            
            NSLog(@"已断开");
            
        }
    };
}

@end
