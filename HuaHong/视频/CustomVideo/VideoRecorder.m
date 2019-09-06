//
//  VideoRecorder.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "VideoRecorder.h"
#import "AssetWriter.h"
#import "SystemCapture.h"

@interface VideoRecorder ()<SystemCaptureDelegate>

@property (nonatomic, strong) SystemCapture *capture;
@property (strong, nonatomic) AssetWriter     *assetWriter;//视频写入

@property (atomic, assign) BOOL isRecording;//正在录制
@property (atomic, assign) BOOL isPaused;//是否暂停
@property (atomic, assign) BOOL isDiscount;//是否中断
@property (atomic, assign) CMTime startTime;//开始录制的时间
@property (atomic, assign) double currentRecordTime;//当前录制时间
@property (atomic, assign) CMTime timeOffset;//录制的偏移CMTime
@property (atomic, assign) CMTime lastVideoTime;//记录上一次视频数据文件的CMTime
@property (atomic, assign) CMTime lastAudioTime;//记录上一次音频数据文件的CMTime

@end

@implementation VideoRecorder

- (instancetype)initWithFrame:(CGRect)frame SuperView:(UIView *)superView
{
    self = [super init];
    if (self) {
     
        [SystemCapture checkCameraAuthor];
        
        //捕获媒体
        _capture = [[SystemCapture alloc] initWithType:SystemCaptureTypeVideo];
    
        [_capture prepareWithPreviewSize:frame.size];  //捕获视频时传入预览层大小
        _capture.preview.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
        self.capture.delegate = self;
        [superView insertSubview:_capture.preview atIndex:0];
        

    }
    
    return self;
}

/**切换摄像头*/
- (void)switchCamera
{
    [self.capture switchCamera];
}
//MARK:
//启动录制功能
- (void)startRunning
{
//    self.startTime = CMTimeMake(0, 0);
//    self.isRecording = NO;
//    self.isPaused = NO;
//    self.isDiscount = NO;
    [self.capture startRunning];
}

//关闭预览
- (void)stopRunning
{
//    _startTime = CMTimeMake(0, 0);
    
    [self.capture stopRunning];
}

//开始录制
- (void)startRecording {
    @synchronized(self) {
        if (!self.isRecording) {
            self.assetWriter = nil;
            self.isPaused = NO;
            self.isDiscount = NO;
            _timeOffset = CMTimeMake(0, 0);
            self.isRecording = YES;
        }
    }
}
//暂停录制
- (void)pauseRecording {
    @synchronized(self) {
        if (self.isRecording) {
            self.isPaused = YES;
            self.isDiscount = YES;
        }
    }
}


//继续录制
- (void)resumeRecording {
    @synchronized(self) {
        if (self.isPaused) {
            self.isPaused = NO;
        }
    }
}

//停止录制
- (void)stopRecordingCompletion:(void (^)(NSURL *outputURL))handler {
    @synchronized(self) {
        if (self.isRecording)
        {
            
            NSURL* url = [NSURL fileURLWithPath:self.assetWriter.path];
            self.isRecording = NO;
            dispatch_async(self.capture.captureQueue, ^{
                [self.assetWriter finishWithCompletionHandler:^{
                    
                    if ([self.delegate respondsToSelector:@selector(recordProgress:Duration:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate recordProgress:self.currentRecordTime/self.maxVideoDuration Duration:self.currentRecordTime];
                        });
                    }
                    
                    self.isRecording = NO;
                    self.assetWriter = nil;
                    
                    //时间恢复为0
                    self.startTime = CMTimeMake(0, 0);
                    self.currentRecordTime = 0;
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (handler) {
                            handler(url);
                        }
                    });
                    
                }];
            });
        }
        
    }
}


#pragma mark - 设置音频格式 调整媒体数据的时间
//调整媒体数据的时间
- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset {
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo* pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++) {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    BOOL isVideo = YES;
    @synchronized(self) {
        if (!self.isRecording  || self.isPaused) {
            return;
        }
        if (![captureOutput isKindOfClass:[AVCaptureVideoDataOutput class]]) {
            isVideo = NO;
        }
        //初始化编码器，当有音频和视频参数时创建编码器
        if (self.assetWriter == nil && isVideo == false)
        {
            //设置音频格式
            CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
            const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
            Float64 _samplerate = asbd->mSampleRate;//音频采样率
            int _channels = asbd->mChannelsPerFrame;//音频通道
            
//            NSString *filePath = [[_videoPath stringByAppendingPathComponent:_videoName] stringByAppendingString:@".mp4"];
          NSString *filePath  = [HHVideoManager getVideoCachePath];
            self.assetWriter = [AssetWriter encoderForPath:filePath Height:_capture.height width:_capture.witdh channels:_channels samples:_samplerate];
        }
        
        //判断是否中断录制过
        if (self.isDiscount)
        {
            if (isVideo) {
                return;
            }
            self.isDiscount = NO;
            // 计算暂停的时间
            CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            CMTime lastTime = isVideo ? _lastVideoTime : _lastAudioTime;
            if (lastTime.flags & kCMTimeFlags_Valid)
            {
                if (_timeOffset.flags)
                {
                    pts = CMTimeSubtract(pts, _timeOffset);
                }
                CMTime offset = CMTimeSubtract(pts, lastTime);
                if (_timeOffset.value == 0) {
                    _timeOffset = offset;
                }else {
                    _timeOffset = CMTimeAdd(_timeOffset, offset);
                }
            }
            _lastVideoTime.flags = 0;
            _lastAudioTime.flags = 0;
        }
        

        if (_timeOffset.value > 0) {
            //根据得到的timeOffset调整
            sampleBuffer = [self adjustTime:sampleBuffer by:_timeOffset];
        }
        
        // 记录暂停上一次录制的时间
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTime dur = CMSampleBufferGetDuration(sampleBuffer);
        if (dur.value > 0) {
            pts = CMTimeAdd(pts, dur);
        }
        if (isVideo) {
            _lastVideoTime = pts;
        }else {
            _lastAudioTime = pts;
        }
    }
    CMTime dur = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if (self.startTime.value == 0) {
        self.startTime = dur;
    }
    CMTime sub = CMTimeSubtract(dur, self.startTime);
    self.currentRecordTime = CMTimeGetSeconds(sub);
    
    if (self.currentRecordTime <= self.maxVideoDuration) {
        
        if ([self.delegate respondsToSelector:@selector(recordProgress:Duration:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate recordProgress:self.currentRecordTime/self.maxVideoDuration Duration:self.currentRecordTime];
            });
        }
        // 进行数据编码
        [self.assetWriter encodeFrame:sampleBuffer isVideo:isVideo];
        
    }else if (self.currentRecordTime > self.maxVideoDuration)
    {
        if ([self.delegate respondsToSelector:@selector(greaterThenMaxDuration)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate greaterThenMaxDuration];
            });
        }
    }
    
    
}

@end

