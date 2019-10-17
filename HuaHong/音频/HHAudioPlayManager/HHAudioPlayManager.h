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
@interface HHAudioPlayManager : NSObject



/**
 *  快速初始化
 *
 *  @return 录音对象
 */
+(HHAudioPlayManager *)sharedManager;



/**
 *  AVPlayer 播放录音
 */
-(void)playAudioWhithURL:(NSString *)urlStr progresscallback:(void(^)(CGFloat progress,NSString *currentTime,NSString *totalTime))progressCallback;

- (void)stop;

@property (nonatomic,copy) void(^playAuidoFinishedCallback)(void);

/** 获取录音时长 */
- (float)getVoiceDuration;

@end
