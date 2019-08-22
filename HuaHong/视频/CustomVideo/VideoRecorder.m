//
//  VideoRecorder.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "VideoRecorder.h"
#import "AssetWriter.h"

@interface VideoRecorder ()<AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureAudioDataOutputSampleBufferDelegate>
{
    CMTime _timeOffset;//录制的偏移CMTime
    CMTime _lastVideo;//记录上一次视频数据文件的CMTime
    CMTime _lastAudio;//记录上一次音频数据文件的CMTime
    NSInteger _cx;//视频分辨的宽
    NSInteger _cy;//视频分辨的高
    int _channels;//音频通道
    Float64 _samplerate;//音频采样率
}

@property (strong, nonatomic) AVCaptureSession           *captureSession;//捕捉会话
@property (copy  , nonatomic) dispatch_queue_t           captureQueue;//录制的队列
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;//预览层layer

@property (strong, nonatomic) AVCaptureDeviceInput       *audioInput;//音频输入
@property (strong, nonatomic) AVCaptureAudioDataOutput   *audioOutput;//音频输出
@property (strong, nonatomic) AVCaptureConnection        *audioConnection;//音频连接

@property (strong, nonatomic) AVCaptureDeviceInput       *videoInput;//视频输入
@property (strong, nonatomic) AVCaptureVideoDataOutput   *videoOutput;//视频输出
@property (strong, nonatomic) AVCaptureConnection        *videoConnection;//视频连接
@property (strong, nonatomic) AssetWriter                *assetWriter;//视频写入

@property (atomic, assign) BOOL isRecording;//正在录制
@property (atomic, assign) BOOL isPaused;//是否暂停
@property (atomic, assign) BOOL isDiscount;//是否中断
@property (atomic, assign) CMTime startTime;//开始录制的时间
@property (atomic, assign) double currentRecordTime;//当前录制时间

@end

@implementation VideoRecorder

#pragma mark - Custom Method

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
            
            NSURL* url = [NSURL fileURLWithPath:[HHVideoManager getVideoCachePath]];
            self.isRecording = NO;
            dispatch_async(_captureQueue, ^{
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
                    
                    if (handler) {
                        handler(url);
                    }
                    
                    
                }];
            });
        }
        
    }
}


#pragma mark - 设置音频格式 调整媒体数据的时间
//设置音频格式
- (void)setAudioFormat:(CMFormatDescriptionRef)fmt {
    const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
    _samplerate = asbd->mSampleRate;
    _channels = asbd->mChannelsPerFrame;
    
}

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
        if (captureOutput != self.videoOutput) {
            isVideo = NO;
        }
        //初始化编码器，当有音频和视频参数时创建编码器
        if ((self.assetWriter == nil) && !isVideo)
        {
            CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
            [self setAudioFormat:fmt];
            
//            NSString *filePath = [[_videoPath stringByAppendingPathComponent:_videoName] stringByAppendingString:@".mp4"];
          NSString *filePath  = [HHVideoManager getVideoCachePath];
            self.assetWriter = [AssetWriter encoderForPath:filePath Height:_cy width:_cx channels:_channels samples:_samplerate];
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
            CMTime last = isVideo ? _lastVideo : _lastAudio;
            if (last.flags & kCMTimeFlags_Valid)
            {
                if (_timeOffset.flags & kCMTimeFlags_Valid)
                {
                    pts = CMTimeSubtract(pts, _timeOffset);
                }
                CMTime offset = CMTimeSubtract(pts, last);
                if (_timeOffset.value == 0) {
                    _timeOffset = offset;
                }else {
                    _timeOffset = CMTimeAdd(_timeOffset, offset);
                }
            }
            _lastVideo.flags = 0;
            _lastAudio.flags = 0;
        }
        
        // 增加sampleBuffer的引用计时,这样我们可以释放这个或修改这个数据，防止在修改时被释放
        CFRetain(sampleBuffer);
        if (_timeOffset.value > 0) {
            CFRelease(sampleBuffer);
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
            _lastVideo = pts;
        }else {
            _lastAudio = pts;
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
        CFRelease(sampleBuffer);
        
    }else if (self.currentRecordTime > self.maxVideoDuration)
    {
        if ([self.delegate respondsToSelector:@selector(greaterThenMaxDuration)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate greaterThenMaxDuration];
            });
        }
    }
    
    
}

//MARK:
//启动录制功能
- (void)startRunning
{
    self.startTime = CMTimeMake(0, 0);
    self.isRecording = NO;
    self.isPaused = NO;
    self.isDiscount = NO;
    [self.captureSession startRunning];
}

//关闭预览
- (void)stopRunning
{
    _startTime = CMTimeMake(0, 0);
    
    [self.captureSession stopRunning];
}

#pragma mark - Lazy Load
- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (_previewLayer == nil) {
        //通过AVCaptureSession初始化
        AVCaptureVideoPreviewLayer *preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        //设置比例为铺满全屏
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer = preview;
    }
    return _previewLayer;
}

//录制的队列
- (dispatch_queue_t)captureQueue {
    if (_captureQueue == nil) {
        _captureQueue = dispatch_queue_create("Capture Queue", DISPATCH_QUEUE_SERIAL);
    }
    return _captureQueue;
}

//捕获视频的会话
- (AVCaptureSession *)captureSession {
    if (_captureSession == nil) {
        _captureSession = [[AVCaptureSession alloc] init];
        
        //添加后置摄像头的输入
        if ([_captureSession canAddInput:self.videoInput]) {
            [_captureSession addInput:self.videoInput];
        }
        
        //添加视频输出
        if ([_captureSession canAddOutput:self.videoOutput]) {
            [_captureSession addOutput:self.videoOutput];
            //设置视频的分辨率
            _cx = 720;
            _cy = 1280;
        }
        
        
        //添加音频输入
        if ([_captureSession canAddInput:self.audioInput]) {
            [_captureSession addInput:self.audioInput];
        }
        //添加音频输出
        if ([_captureSession canAddOutput:self.audioOutput]) {
            [_captureSession addOutput:self.audioOutput];
        }
        //设置视频录制的方向
        self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
    }
    
    return _captureSession;
}


- (AVCaptureDeviceInput *)videoInput
{
    if (!_videoInput) {
        NSError *error;
        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (error) {
            NSLog(@"获取默认摄像头失败");
        }
    }
    
    return _videoInput;
}

//视频输出
- (AVCaptureVideoDataOutput *)videoOutput {
    if (_videoOutput == nil) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
        _videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      
                                      [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                      nil];
    }
    return _videoOutput;
}

//音频输入
- (AVCaptureDeviceInput *)audioInput {
    if (_audioInput == nil) {
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error;
        _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        if (error) {
            NSLog(@"获取麦克风失败~");
        }
    }
    return _audioInput;
}

//音频输出
- (AVCaptureAudioDataOutput *)audioOutput {
    if (_audioOutput == nil) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioOutput setSampleBufferDelegate:self queue:self.captureQueue];
    }
    return _audioOutput;
}

//视频连接
- (AVCaptureConnection *)videoConnection {
    _videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    return _videoConnection;
}

//音频连接
- (AVCaptureConnection *)audioConnection {
    if (_audioConnection == nil) {
        _audioConnection = [self.audioOutput connectionWithMediaType:AVMediaTypeAudio];
    }
    return _audioConnection;
    
}

//用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

@end

