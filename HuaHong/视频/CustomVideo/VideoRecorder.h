//
//  VideoRecorder.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VideoRecordDelegate <NSObject>

- (void)recordProgress:(CGFloat)progress;

@end

@interface VideoRecorder : NSObject

@property (nonatomic, assign) NSInteger maxVideoDuration;   //最长视频时长

//状态输出
@property (atomic, assign, readonly) BOOL isCapturing;//正在录制
@property (atomic, assign, readonly) BOOL isPaused;//是否暂停
@property (nonatomic, weak) id <VideoRecordDelegate> delegate;

//捕获到的视频呈现的layer
- (AVCaptureVideoPreviewLayer *)previewLayer;

//启动录制功能
- (void)openPreview;

//关闭录制功能
- (void)closePreview;

//开始录制
- (void)startRecording;

//暂停录制
- (void)pauseRecording;

//停止录制
- (void)stopRecordingCompletion:(void (^)(NSURL *outputURL))handler;

//继续录制
- (void)resumeRecording;

//开启闪光灯
- (void)switchFlashLight;

//切换前后置摄像头
- (void)switchCamera;

@end

