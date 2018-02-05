//
//  VoiceManager.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/1.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "VoiceManager.h"

@interface VoiceManager()
@property (nonatomic,strong)AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *speechRequest; // 语音请求对象
@property (nonatomic, strong) SFSpeechRecognitionTask *currentSpeechTask;          // 当前语音识别进程
@end
@implementation VoiceManager

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

+(void)convert
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
                break;
        }
    }];
    
    SFSpeechAudioBufferRecognitionRequest *request = [SFSpeechAudioBufferRecognitionRequest new];
    AVAudioEngine *audioEngine = [AVAudioEngine new];
    [audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:[audioEngine.inputNode outputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        
        [request appendAudioPCMBuffer:buffer];
    }];
    
    [audioEngine prepare];
}
@end

