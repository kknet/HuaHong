//
//  VideoRecorder.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoRecordDelegate <NSObject>

@optional
//录制进度currentRecordTime/maxVideoDuration
- (void)recordProgress:(CGFloat)progress Duration:(double)duration;
//大于最大时长
- (void)greaterThenMaxDuration;
//截取图片
- (void)faceScanResult:(NSData *)imageData;
@end

@interface VideoRecorder : NSObject

@property (nonatomic,copy) NSString *videoPath;
@property (nonatomic,copy) NSString *videoName;
@property (nonatomic, assign) CGFloat maxVideoDuration;//最大时长

//状态输出
@property (atomic, assign, readonly) BOOL isCapturing;//正在录制
@property (atomic, assign, readonly) BOOL isPaused;//是否暂停
@property (nonatomic, weak) id <VideoRecordDelegate> delegate;

//捕获到的视频呈现的layer
- (AVCaptureVideoPreviewLayer *)previewLayer;

//开始录制
- (void)startRecording;

//暂停录制
- (void)pauseRecording;

//停止录制
- (void)stopRecordingCompletion:(void (^)(NSURL *outputURL))handler;

//继续录制
- (void)resumeRecording;

//切换前后置摄像头
- (void)switchCamera;

//截取图片
- (void)shutterCamera;

//启动录制功能
- (void)startRunning;

//关闭录制功能
- (void)stopRunning;
@end

