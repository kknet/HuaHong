//
//  VoiceManager.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/1.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "VoiceManager.h"

@implementation VoiceManager

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

+ (void)stopBroadcastVoice:(AVSpeechSynthesizer *)voice{
    
    [voice continueSpeaking];
}

@end

