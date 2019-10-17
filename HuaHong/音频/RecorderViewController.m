//
//  RecorderViewController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/6.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "RecorderViewController.h"
#import "HHAudioRecorder.h"
#import "HHAudioAVPlayer.h"

@interface RecorderViewController ()

@end

@implementation RecorderViewController
{
    HHAudioRecorder *recorde;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"录音" style:UIBarButtonItemStylePlain target:self action:@selector(recodeVoice)];

}

-(void)recodeVoice
{
    recorde = [HHAudioRecorder sharedManager];
//    recorde.fileName = @"";
//    recorde.recordLength = 0;
    
    [recorde setRecordeBlock:^(NSString *recordePath) {
        
        NSLog(@"recordePath:%@",recordePath);
    }];
    
    [recorde record];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
        [recorde stop];
    
//   NSString *path = [[NSBundle mainBundle]pathForResource:@"12345" ofType:@"caf"];
//    [[HHAudioAVPlayer sharedManager]playAudioWhithURL:path progresscallback:^(CGFloat progress, NSString *currentTime, NSString *totalTime) {
//
//    }];
}
@end
