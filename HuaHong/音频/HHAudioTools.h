//
//  HHAudioTools.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/9.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

typedef void(^RecordeBlock)(NSString *recordePath);
@interface HHAudioTools : NSObject<AVAudioRecorderDelegate,AVSpeechSynthesizerDelegate,AVAudioRecorderDelegate,SFSpeechRecognizerDelegate>

#pragma mark - 播放音效
/** 播放系统音效*/
+ (void)playSystemSoundWithURL:(NSURL *)url;

/** 播放震动音效*/
+ (void)playAlertSoundWithURL:(NSURL *)url;

/** 清空音效文件的内存*/
+ (void)clearMemory;

/**
 *  快速初始化
 *
 *  @return 录音对象
 */
+(HHAudioTools *)sharedTools;

#pragma mark - 录音

/**
 *  录音文件名字(必须要设置)
 */
@property (nonatomic,copy) NSString *recordeFileName;

@property (nonatomic,copy) RecordeBlock recordeBlock;

/**
 *  开始录音
 *
 *  @param length 录音时长
 */
-(void)startRecorde:(NSTimeInterval)length;

/**
 *  暂停录音
 */
-(void)pauseRecorde;

/**
 *  暂停后 继续开始录音
 */
-(void)continueRecorde;

/**
 *  结束录音
 */
-(void)stopRecorde:(BOOL)isSave;

/**
 *  获取录音总时间
 */
//-(NSInteger)getRecordeTotalTime;

/**
 *  获取录音地址
 */
-(NSString *)getRecordePath;

/**
 *  删除录音
 */
-(void)deleteRecord;

//- (void)deleteMP3;

/**
 *  重置录音器
 */
-(void)resetRecorder;

#pragma mark - 播放录音
/**
 *  AVAudioPlayer 播放录音
 */
-(void)playRecord:(NSString *)urlStr;
-(void)AVAudioStop;
/**
 *  AVPlayer 播放录音
 */
-(void)playAudioWhithURL:(NSString *)urlStr progresscallback:(void(^)(CGFloat progress,NSString *currentTime,NSString *totalTime))progressCallback;

- (void)stopPlayAudio;

@property (nonatomic,copy) void(^playAuidoFinishedCallback)(void);

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

+(void)convert;

@end

