//
//  HHAudioConvertManager.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/1.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>


@interface HHAudioConvertManager : NSObject<SFSpeechRecognizerDelegate,AVSpeechSynthesizerDelegate>

#pragma mark - 文字转语音
/**
 user : self
 speed : 0-1之间
 languageType : 语种
 volume :音量 [0-1] Default = 1
 tone : 音调 [0.5 - 2] Default = 1
 */

/** 语种
 "zh-HK",中文(香港)粤语
 "zh-TW",中文(台湾)
 "zh-CN",中文(普通话)
 "en-GB",英语(英国)
 "en-US",英语(美国)
 */
+ (void)startBroadcastVoice:(id)user speed:(NSInteger)speed volume:(NSInteger)volume tone:(NSInteger)tone voice:(AVSpeechSynthesizer *)voice LanguageType:(NSString *)languageType content:(NSString *)content;

/** 停止播报
 voice : 初始化类名
 */
+ (void)stopBroadcastVoice:(AVSpeechSynthesizer *)voice;

#pragma mark - 语音转文字
+(void)convertToTextWithVoice:(NSString *)voicename;

+ (HHAudioConvertManager *)shared;

- (void)build;
-(void)convert;
@end
