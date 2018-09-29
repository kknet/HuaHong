//
//  hhController.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/2.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "hhController.h"
#import <Speech/Speech.h>
@interface hhController ()<SFSpeechRecognizerDelegate>

@property (nonatomic, strong) AVAudioEngine *audioEngine;                           // 声音处理器
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;                 // 语音识别器
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *speechRequest; // 语音请求对象
@property (nonatomic, strong) SFSpeechRecognitionTask *currentSpeechTask;           // 当前语音识别进程
@property (nonatomic, strong) UILabel *showLb;       // 用于展现的label
@property (nonatomic, strong) UIButton *startBtn;    // 启动按钮


@end

@implementation hhController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.startBtn];
    
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status)
     {
         if (status != SFSpeechRecognizerAuthorizationStatusAuthorized)
         {
             // 如果状态不是已授权则return
             self.startBtn.backgroundColor = [UIColor grayColor];
             return;
         }
         
         self.startBtn.enabled = YES;
     }];
    
}
- (void)recorderAction
{
    
    if ([self.audioEngine isRunning]) {
        [self stopDictating];
        [self.startBtn setTitle:@"开始录音" forState:UIControlStateNormal];
    }else
    {
      [self startDictating];
        [self.startBtn setTitle:@"关闭" forState:UIControlStateNormal];

    }
    
}


- (void)startDictating
{
    if (_currentSpeechTask) {
        [self.currentSpeechTask cancel];
        self.currentSpeechTask = nil;
    }
  
    NSError *error;

//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
//   BOOL audioBool1 = [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
//    NSParameterAssert(!error);
//
//    BOOL audioBool2 = [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
//    NSParameterAssert(!error);
//
//    BOOL audioBool3 = [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation  error:&error];
//    NSParameterAssert(!error);
//
//    if(audioBool1 || audioBool2 || audioBool3) {
//        NSLog(@"可以使用");
//
//    }else{
//        NSLog(@"这里说明有的功能不支持");
//    }
    
    // 初始化
    self.speechRequest = [SFSpeechAudioBufferRecognitionRequest new];
//    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    NSAssert(self.audioEngine.inputNode,@"录入设备没有准备好");
    NSAssert(self.speechRequest, @"请求初始化失败");
    
    self.speechRequest.shouldReportPartialResults = YES;

    self.currentSpeechTask =
    [self.speechRecognizer recognitionTaskWithRequest:self.speechRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result,NSError * _Nullable error)
     {
         // 识别结果，识别后的操作
         if (result == NULL) return;
         BOOL isfinal = NO;
         
         if (result) {
             self.showLb.text = result.bestTranscription.formattedString;
             isfinal = [result isFinal];
         }
         
         if (error || isfinal) {
             [self.audioEngine stop];
             [self.audioEngine.inputNode removeTapOnBus:0];
             self.speechRequest = nil;
             self.currentSpeechTask = nil;
             [self.startBtn setTitle:@"开始录音" forState:UIControlStateNormal];
             self.startBtn.enabled = YES;
         }
         
     }];
    
//    AVAudioFormat *format = [inputNode outputFormatForBus:0];
    
    //在添加tap之前先移除上一个  不然有可能报"Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio',"之类的错误
    [self.audioEngine.inputNode removeTapOnBus:0];
    
    // 初始化语音处理器的输入模式
    [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:[self.audioEngine.inputNode outputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer,AVAudioTime * _Nonnull when)
     {
         // 为语音识别请求对象添加一个AudioPCMBuffer，来获取声音数据
         [self.speechRequest appendAudioPCMBuffer:buffer];
     }];
    // 语音处理器准备就绪（会为一些audioEngine启动时所必须的资源开辟内存）
    [self.audioEngine prepare];
    
    // 启动声音处理器
    [self.audioEngine startAndReturnError: &error];
    NSParameterAssert(!error);
    
    self.startBtn.enabled = YES;

    self.showLb.text = @"正在录音...";
    
   
}

- (void)stopDictating
{
    // 停止声音处理器，停止语音识别请求进程
    [self.audioEngine stop];
    
    [self.speechRequest endAudio];
 
    
    if (_currentSpeechTask) {
        [_currentSpeechTask cancel];
        _currentSpeechTask = nil;
    }
    
    self.startBtn.enabled = NO;
}


#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available
{
    if (available) {
        self.startBtn.enabled = YES;
        [self.startBtn setTitle:@"开始录音" forState:UIControlStateNormal];
    }else
    {
        self.startBtn.enabled = NO;
        [self.startBtn setTitle:@"语音识别不可用" forState:UIControlStateNormal];
    }
}

#pragma mark- getter
- (SFSpeechRecognizer *)speechRecognizer
{
    if (!_speechRecognizer) {
        NSLocale *local = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _speechRecognizer = [[SFSpeechRecognizer alloc]initWithLocale:local];
        _speechRecognizer.delegate = self;
    }
    
    return _speechRecognizer;
}

- (AVAudioEngine *)audioEngine
{
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc]init];
    }
    return _audioEngine;
}
- (UILabel *)showLb {
    if (!_showLb) {
        _showLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 180, self.view.bounds.size.width - 100, 100)];
        _showLb.numberOfLines = 0;
        
        //设置字体随系统变化动态调整大小 iOS10
        // 1. 设置 font 大小
        _showLb.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        // 2. 允许调整大小
        _showLb.adjustsFontForContentSizeCategory = YES;
        
        _showLb.text = @"等待中...";
        _showLb.textColor = [UIColor orangeColor];
        [self.view addSubview:_showLb];
    }
    return _showLb;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(50, 80, 80, 80);
        [_startBtn addTarget:self action:@selector(recorderAction) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setBackgroundColor:[UIColor redColor]];
        [_startBtn setTitle:@"录音" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startBtn.enabled = NO;
        
    }
    return _startBtn;
}


@end
