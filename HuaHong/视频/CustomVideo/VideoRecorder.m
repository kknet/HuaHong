//
//  VideoRecorder.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "VideoRecorder.h"
#import "AssetWriter.h"
#import <Photos/Photos.h>

@interface VideoRecorder ()<AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureAudioDataOutputSampleBufferDelegate,
CAAnimationDelegate>
{
    CMTime _timeOffset;//录制的偏移CMTime
    CMTime _lastVideo;//记录上一次视频数据文件的CMTime
    CMTime _lastAudio;//记录上一次音频数据文件的CMTime
    
    NSInteger _cx;//视频分辨的宽
    NSInteger _cy;//视频分辨的高
    int _channels;//音频通道
    Float64 _samplerate;//音频采样率
}

@property (strong, nonatomic) AVCaptureSession           *captureSession;//捕获视频的会话
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;//捕获到的视频呈现的layer
@property (strong, nonatomic) AVCaptureDeviceInput       *backCameraInput;//后置摄像头输入
@property (strong, nonatomic) AVCaptureDeviceInput       *frontCameraInput;//前置摄像头输入
@property (strong, nonatomic) AVCaptureDeviceInput       *audioMicInput;//麦克风输入
@property (copy  , nonatomic) dispatch_queue_t           captureQueue;//录制的队列
@property (strong, nonatomic) AVCaptureConnection        *audioConnection;//音频录制连接
@property (strong, nonatomic) AVCaptureConnection        *videoConnection;//视频录制连接
@property (strong, nonatomic) AVCaptureVideoDataOutput   *videoOutput;//视频输出
@property (strong, nonatomic) AVCaptureAudioDataOutput   *audioOutput;//音频输出
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;

//录制写入
@property (nonatomic, strong) AssetWriter *assetWriter;

//照片输出流
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
//录制状态
@property (atomic, assign) BOOL isCapturing;//正在录制
@property (atomic, assign) BOOL isPaused;//是否暂停
@property (atomic, assign) BOOL isDiscount;//是否中断
@property (nonatomic, assign) BOOL isFront;
@property (atomic, assign) CMTime startTime;//开始录制的时间
@property (atomic, assign) double currentRecordTime;//当前录制时间
@property(nonatomic)AVCaptureDevice *device;

@end

@implementation VideoRecorder

#pragma mark - Custom Method

//开始录制
- (void)startRecording {
    @synchronized(self) {
        if (!self.isCapturing) {
            self.assetWriter = nil;
            self.isPaused = NO;
            self.isDiscount = NO;
            _timeOffset = CMTimeMake(0, 0);
            self.isCapturing = YES;
        }
    }
}
//暂停录制
- (void)pauseRecording {
    @synchronized(self) {
        if (self.isCapturing) {
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
        if (self.isCapturing)
        {
            
            NSURL* url = [NSURL fileURLWithPath:self.assetWriter.path];
            self.isCapturing = NO;
            dispatch_async(_captureQueue, ^{
                [self.assetWriter finishWithCompletionHandler:^{
                    
                    if ([self.delegate respondsToSelector:@selector(recordProgress:Duration:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate recordProgress:self.currentRecordTime/self.maxVideoDuration Duration:self.currentRecordTime];
                        });
                    }
                    
                    self.isCapturing = NO;
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

//切换前后置摄像头
- (void)switchCamera{
//    if (self.isFront)
//    {
//        [self.captureSession stopRunning];
//        [self.captureSession removeInput:self.frontCameraInput];
//        if ([self.captureSession canAddInput:self.backCameraInput]) {
//            [self changeCameraAnimation];
//            [self.captureSession addInput:self.backCameraInput];
//        }
//        self.isFront = NO;
//
//    }else
//    {
//        [self.captureSession stopRunning];
//        [self.captureSession removeInput:self.backCameraInput];
//        if ([self.captureSession canAddInput:self.frontCameraInput]) {
//            [self changeCameraAnimation];
//            [self.captureSession addInput:self.frontCameraInput];
//        }
//        self.isFront = YES;
//    }
    
    AVCaptureDeviceInput *switchInput;
    if (self.videoInput.device.position == AVCaptureDevicePositionBack)
    {
        //切换至前摄像头
        //        AVCaptureDevice *frontCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        //        switchInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:nil];
        switchInput = self.frontCameraInput;
        
    }else
    {
        //切换至后摄像头
        //       AVCaptureDevice *backCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        //       switchInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
        switchInput = self.backCameraInput;
        
    }
    
    if (switchInput == nil) {
        return;
    }
    
    [self.captureSession beginConfiguration];
    [self.captureSession removeInput:self.videoInput];
    
    if ([self.captureSession canAddInput:switchInput])
    {
        [self.captureSession addInput:switchInput];
        self.videoInput = switchInput;
        [self changeCameraAnimation];
        
    }else
    {
        if ([self.captureSession canAddInput:self.videoInput]) {
            [self.captureSession addInput:self.videoInput];
        }
    }
    
    [self.captureSession commitConfiguration];
}

#pragma mark - Private Method
- (void)changeCameraAnimation {
    CATransition *changeAnimation = [CATransition animation];
    changeAnimation.delegate = self;
    changeAnimation.duration = 0.5;
    changeAnimation.type = @"oglFlip";
    //    changeAnimation.type = kCATransitionMoveIn;
    
    changeAnimation.subtype = kCATransitionFromRight;
    changeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.previewLayer addAnimation:changeAnimation forKey:@"changeAnimation"];
}


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
        if (!self.isCapturing  || self.isPaused) {
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
            
            NSString *filePath = [[_videoPath stringByAppendingPathComponent:_videoName] stringByAppendingString:@".mp4"];
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


#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    
//    [self.captureSession startRunning];
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
        _captureQueue = dispatch_queue_create("name", DISPATCH_QUEUE_SERIAL);
    }
    return _captureQueue;
}

- (AVCaptureStillImageOutput *)ImageOutPut
{
    if (!_ImageOutPut) {
        _ImageOutPut = [[AVCaptureStillImageOutput alloc]init];
    }
    
    return _ImageOutPut;
}
//捕获视频的会话
- (AVCaptureSession *)captureSession {
    if (_captureSession == nil) {
        _captureSession = [[AVCaptureSession alloc] init];
        
        //添加后置摄像头的输入
        self.videoInput = self.backCameraInput;
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
        
        //添加图片输出
        if ([_captureSession canAddOutput:self.ImageOutPut]) {
            [_captureSession addOutput:self.ImageOutPut];
            
        }
        
        //添加音频输入
        if ([_captureSession canAddInput:self.audioMicInput]) {
            [_captureSession addInput:self.audioMicInput];
        }
        //添加音频输出
        if ([_captureSession canAddOutput:self.audioOutput]) {
            [_captureSession addOutput:self.audioOutput];
        }
        //设置视频录制的方向
        self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
        
        //修改设备的属性，先加锁
        if ([self.device lockForConfiguration:nil]) {
            //闪光灯自动
            if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [self.device setFlashMode:AVCaptureFlashModeAuto];
            }
            //自动白平衡
            if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
                [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
            }
            //解锁
            [self.device unlockForConfiguration];
        }
    }
    return _captureSession;
}

//后置摄像头输入
- (AVCaptureDeviceInput *)backCameraInput {
    if (_backCameraInput == nil) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionBack] error:&error];
        if (error) {
            NSLog(@"获取后置摄像头失败~");
        }
    }
    return _backCameraInput;
}

//前置摄像头输入
- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        if (error) {
            NSLog(@"获取前置摄像头失败~");
        }
    }
    return _frontCameraInput;
}

//麦克风输入
- (AVCaptureDeviceInput *)audioMicInput {
    if (_audioMicInput == nil) {
        AVCaptureDevice *mic = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error;
        _audioMicInput = [AVCaptureDeviceInput deviceInputWithDevice:mic error:&error];
        if (error) {
            NSLog(@"获取麦克风失败~");
        }
    }
    return _audioMicInput;
}

//视频输出
- (AVCaptureVideoDataOutput *)videoOutput {
    if (_videoOutput == nil) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
        NSDictionary* setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        _videoOutput.videoSettings = setcapSettings;
    }
    return _videoOutput;
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
    //返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    //遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}


#pragma mark- 捕捉静态图片
- (void)captureStillImage
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __weak typeof(self) weakSelf = self;
        
        AVCaptureConnection * videoConnection = [weakSelf.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
        if (videoConnection ==  nil) {
            return;
        }
        
        //消除取图片时的声音。
        static SystemSoundID soundID = 0;
        if (soundID == 0) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"photoShutter" ofType:@"caf"];
            NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        }
        AudioServicesPlaySystemSound(soundID);
        
        @weakify(self);
        [weakSelf.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            @strongify(self);
            if (imageDataSampleBuffer == nil) {
                return;
            }
            
            NSData *imageData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            if ([self.delegate respondsToSelector:@selector(faceScanResult:)]) {
                [self.delegate faceScanResult:imageData];
            }
            
        }];
    });
    
}

//启动录制功能
- (void)startRunning
{
    self.startTime = CMTimeMake(0, 0);
    self.isCapturing = NO;
    self.isPaused = NO;
    self.isDiscount = NO;
    self.isFront = NO;
    [self.captureSession startRunning];
}

//关闭预览
- (void)stopRunning
{
    _startTime = CMTimeMake(0, 0);
    
    [self.captureSession stopRunning];
}

- (void)focusAtPoint:(CGPoint)point{
    //    CGSize size = self.view.bounds.size;
    CGSize size = [UIScreen mainScreen].bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    
    if ([self.device lockForConfiguration:nil]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
    }
    
}

- (AVCaptureDevice *)device
{
    if (!_device) {
        _device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    }
    
    return _device;
}
@end

