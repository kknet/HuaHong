//
//  CCSystemCapture.h
//  HuaHong
//
//  Created by qk-huahong on 2019/8/21.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//捕获类型
typedef NS_ENUM(int,SystemCaptureType){
    SystemCaptureTypeVideo = 0,   //视频和音频都有，适合自定义录制视频
    SystemCaptureTypeAudio,       //只有音频
    SystemCaptureTypeMovie,       //影片录制，movie file output
    SystemCaptureTypeStillImage,  //静态图片，只有视频，无音频
    SystemCaptureTypeMetadata     //二维码，人脸识别

    
};

@protocol SystemCaptureDelegate <NSObject>
@optional

//AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

//AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections;
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error;
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection;

-(void)captureOutput:(AVCaptureOutput *)captureOutput captureStillImage:(NSData *)imageData;
@end

/**捕获音视频*/
@interface CCSystemCapture : NSObject
/**预览层*/
@property (nonatomic, strong) UIView *preview;
@property (nonatomic, weak) id<SystemCaptureDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isRecording;//正在录制
@property (copy,   nonatomic) dispatch_queue_t captureQueue;//录制队列
@property (atomic, assign) NSUInteger witdh;/**捕获视频的宽*/
@property (atomic, assign) NSUInteger height;/**捕获视频的高*/

- (instancetype)initWithType:(SystemCaptureType)type;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

/** 准备工作(只捕获音频时调用)*/
- (void)prepare;
//捕获内容包括视频时调用（预览层大小，添加到view上用来显示）
- (void)prepareWithPreviewSize:(CGSize)size;

/**开始*/
- (void)startRunning;
/**结束*/
- (void)stopRunning;

/**切换摄像头*/
- (void)switchCamera;
//设置手电筒模式
- (void)setTorchModel:(AVCaptureTorchMode)torchModel;
//设置闪光灯模式
- (void)setFlashMode:(AVCaptureFlashMode)flashModel;

#pragma mark - movie
- (void)startMovieRecording;
- (void)stopMovieRecording;
- (CMTime)movieRecordDuration;

#pragma mark - 捕捉静态图片
- (void)captureStillImage;

#pragma mark - 授权检测
+ (int)checkMicrophoneAuthor;
+ (int)checkCameraAuthor;

@end
