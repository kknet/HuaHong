//
//  RecorderViewController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/6.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "RecorderViewController.h"
#import "HHAudioTools.h"

@interface RecorderViewController ()

@end

@implementation RecorderViewController
{
    HHAudioTools *recorde;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"录音" style:UIBarButtonItemStylePlain target:self action:@selector(recodeVoice)];

}

-(void)recodeVoice
{
    recorde = [HHAudioTools sharedTools];
    recorde.recordeFileName = @"12345";
    __weak typeof(recorde) weakrecorde = recorde;
    [recorde setRecordeBlock:^(NSString *recordePath) {
        [weakrecorde playRecord:recordePath];
    }];
    
    [recorde startRecorde:10];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    recorde = [HHAudioTools sharedTools];
    
    [recorde stopRecorde:YES];
}
@end
