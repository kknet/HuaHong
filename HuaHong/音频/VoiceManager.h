//
//  VoiceManager.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/1.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface VoiceManager : NSObject<AVSpeechSynthesizerDelegate,AVAudioRecorderDelegate>

/** 文字转语音
 user : self
 speed : 0-1之间
 languageType : 语种
 volume :音量 [0-1] Default = 1
 tone : 音调 [0.5 - 2] Default = 1
 */

/** 语种
 "[AVSpeechSynthesisVoice 0x978b2d0] Language: zh-HK",中文(香港)粤语
 
 "[AVSpeechSynthesisVoice 0x978b440] Language: zh-TW",中文(台湾)
 
 "[AVSpeechSynthesisVoice 0x978b4e0] Language: zh-CN",中文(普通话)
 
 "[AVSpeechSynthesisVoice 0x978b580] Language: en-GB",英语(英国)
 
 "[AVSpeechSynthesisVoice 0x978b810] Language: en-US",英语(美国)
 
 */
+ (void)startBroadcastVoice:(id)user speed:(NSInteger)speed volume:(NSInteger)volume tone:(NSInteger)tone voice:(AVSpeechSynthesizer *)voice LanguageType:(NSString *)languageType content:(NSString *)content;

/** 停止播报
 voice : 初始化类名
 */
+ (void)stopBroadcastVoice:(AVSpeechSynthesizer *)voice;

@end

