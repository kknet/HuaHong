//
//  HHAudioPlayManager.h
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^RecordeBlock)(NSString *recordePath);
@interface HHAudioPlayManager : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

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
+(HHAudioPlayManager *)sharedManager;


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

/** 获取录音时长 */
- (float)getVoiceDuration;
@end
