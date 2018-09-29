//
//  HHAudioConvertManager.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/1.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHAudioConvertManager.h"

@interface HHAudioConvertManager ()
/** 语音识别 */
@property (nonatomic, strong) AVAudioEngine *audioEngine;                           // 声音处理器
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;                 // 语音识别器
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *speechRequest; // 语音请求对象
@property (nonatomic, strong) SFSpeechRecognitionTask *currentSpeechTask;           // 当前语音识别进程@end
@end
@implementation HHAudioConvertManager

#pragma mark - 语音转文字/文字转语音
//文字转语音
+ (void)startBroadcastVoice:(id)user speed:(NSInteger)speed volume:(NSInteger)volume tone:(NSInteger)tone voice:(AVSpeechSynthesizer *)voice LanguageType:(NSString *)languageType content:(NSString *)content {
    
    voice.delegate= user;
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:content];
    
    utterance.pitchMultiplier = tone;
    utterance.volume = volume;
    
    utterance.rate= speed;
    
    AVSpeechSynthesisVoice *language = [AVSpeechSynthesisVoice voiceWithLanguage:languageType];
    
    utterance.voice= language;
    
    [voice speakUtterance:utterance];
    
}

//文字转语音停止
+ (void)stopBroadcastVoice:(AVSpeechSynthesizer *)voice{
    
    [voice continueSpeaking];
}

#pragma mark - 本地语音转文字
+(void)convertToTextWithVoice:(NSString *)voicename
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
        return;
    }
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"授权成功");
                break;
                
            default:
                NSLog(@"授权失败");
                return;
                break;
        }
    }];
    
    
    SFSpeechRecognizer *recognizer = [[SFSpeechRecognizer alloc]initWithLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:voicename ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc]initWithURL:url];
    
    [recognizer recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (error == nil) {
            NSString *value = result.bestTranscription.formattedString;
            NSLog(@"value:%@",value);
        }else
        {
            NSLog(@"error:%@",error);
        }
        
    }];
}

+ (HHAudioConvertManager *)shared
{
   static HHAudioConvertManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HHAudioConvertManager alloc]init];
    });
    
    return instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)build
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
        return;
    }
    
    self.audioEngine = [AVAudioEngine new];
    
    NSLocale *local = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.speechRecognizer = [[SFSpeechRecognizer alloc]initWithLocale:local];
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status)
     {
         if (status != SFSpeechRecognizerAuthorizationStatusAuthorized)
         {
             // 如果状态不是已授权则return
             return;
         }
         
         // 初始化语音处理器的输入模式
         [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:[self.audioEngine.inputNode outputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer,AVAudioTime * _Nonnull when)
          {
              // 为语音识别请求对象添加一个AudioPCMBuffer，来获取声音数据
              [self.speechRequest appendAudioPCMBuffer:buffer];
          }];
         // 语音处理器准备就绪（会为一些audioEngine启动时所必须的资源开辟内存）
         [self.audioEngine prepare];
         
     }];
}
-(void)convert
{
    if (self.currentSpeechTask.state == SFSpeechRecognitionTaskStateRunning)
    {
        // 如果当前进程状态是进行中
        // 停止语音识别
        [self stopDictating];
    }
    else
    {
        // 进程状态不在进行中
        // 开启语音识别
        [self startDictating];
    }
}

- (void)startDictating
{
    NSError *error;
    // 启动声音处理器
    [self.audioEngine startAndReturnError: &error];
    // 初始化
    self.speechRequest = [SFSpeechAudioBufferRecognitionRequest new];
    
    self.currentSpeechTask =
    [self.speechRecognizer recognitionTaskWithRequest:self.speechRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result,NSError * _Nullable error)
     {
         // 识别结果，识别后的操作
         if (result == NULL) return;
         NSLog(@"%@",result.bestTranscription.formattedString);
     }];
}

- (void)stopDictating
{
    // 停止声音处理器，停止语音识别请求进程
    [self.audioEngine stop];
    [self.speechRequest endAudio];
}


@end
