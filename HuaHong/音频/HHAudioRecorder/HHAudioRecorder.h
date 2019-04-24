//
//  HHAudioRecorder.h
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HHAudioRecorder : NSObject<AVAudioRecorderDelegate>

+(HHAudioRecorder *)sharedManager;

//录音文件名字(必须要设置)
@property (nonatomic,copy) NSString *fileName;

//录音时长
@property (nonatomic,assign) NSTimeInterval recordLength;
    
@property (nonatomic,copy) void(^recordeBlock)(NSString *recordePath);

//开始录音
-(void)startRecorde;

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

@end
