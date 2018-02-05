//
//  VoiceController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/1.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "VoiceController.h"
#import "VoiceManager.h"

@interface VoiceController ()

@end

@implementation VoiceController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIButton *voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
//    voiceBtn.backgroundColor = [UIColor orangeColor];
//    [voiceBtn setTitle:@"文字转语音" forState:UIControlStateNormal];
//    [voiceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [voiceBtn addTarget:self action:@selector(voiceBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:voiceBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"文字转语音" style:UIBarButtonItemStylePlain target:self action:@selector(voiceBtn:)];

    
}

- (void)voiceBtn:(UIButton *)btn{
    
    
    AVSpeechSynthesizer *voice= [[AVSpeechSynthesizer alloc]init];
    
    if ([voice isPaused]) {
        
        [VoiceManager stopBroadcastVoice:voice];
        
    }else{
        
        [VoiceManager startBroadcastVoice:self speed:0.95 volume:1 tone:1 voice:voice LanguageType:@"zh_CN" content:@"安得广厦千万间，大庇天下寒士俱欢颜，风雨不动安如山。"];
    }
    
    
    
    //[voice pauseSpeakingAtBoundary:AVSpeechBoundaryWord];//暂停
    

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [VoiceManager convertToTextWithVoice:@"黑马程序员.mp3"];
}

@end
