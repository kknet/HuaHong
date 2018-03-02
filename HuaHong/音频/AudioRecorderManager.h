//
//  AudioRecorderManager.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/6.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^RecordeBlock)(NSString *recordePath);
@interface AudioRecorderManager : NSObject<AVAudioRecorderDelegate>

/***  是否保存  */
@property (nonatomic,assign) BOOL isSave;

@property (nonatomic,copy) RecordeBlock recordeBlock;

/***  录音对象  */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** 当前暂停的时间 */
@property (nonatomic,assign) NSTimeInterval pauseTime;

/** 最终录音总时间 */
//@property (nonatomic,assign) NSTimeInterval recordeTotalTime;

/**
 *  录音文件名字(必须要设置)
 */
@property (nonatomic,copy) NSString *recordeFileName;

/**
 *  设置录音最大时长（默认为60秒）
 */
//@property(assign, nonatomic) NSInteger recordeMaxTime;

/**
 *  快速初始化
 *
 *  @return 录音对象
 */
+(AudioRecorderManager *)sharedRecorde;

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

/**
 *  播放录音
 */
-(void)playRecord:(NSString *)recordPath;



@end
