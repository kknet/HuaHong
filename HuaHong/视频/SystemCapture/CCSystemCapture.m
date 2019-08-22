//
//  CCSystemCapture.m
//  HuaHong
//
//  Created by qk-huahong on 2019/8/21.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "CCSystemCapture.h"
@interface CCSystemCapture ()<AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate>

/********************公共*************/
@property (strong, nonatomic) AVCaptureSession           *captureSession;//捕捉会话
@property (copy,   nonatomic) dispatch_queue_t           captureQueue;//录制队列

/********************音频相关**********/
@property (strong, nonatomic) AVCaptureDeviceInput       *audioInput;//音频输入
@property (strong, nonatomic) AVCaptureAudioDataOutput   *audioOutput;//音频输出
@property (strong, nonatomic) AVCaptureConnection        *audioConnection;//音频连接

/********************视频相关**********/
@property (strong, nonatomic) AVCaptureDeviceInput       *videoInput;//视频输入
@property (strong, nonatomic) AVCaptureVideoDataOutput   *videoOutput;//视频输出
@property (strong, nonatomic) AVCaptureConnection        *videoConnection;//视频连接
//@property (strong, nonatomic) AssetWriter                *assetWriter;//视频写入
@property (strong, nonatomic) AVCaptureMovieFileOutput   *movieOutput;//影片输出

/********************静态图片捕捉**********/
@property (strong, nonatomic) AVCaptureStillImageOutput  *imageOutPut;//静态图片输出

/********************预览层**********/
@property (assign, nonatomic) CGSize                      prelayerSize;//预览窗口大小
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;//预览层layer

/************其它******************/
@property (atomic, assign) BOOL isPaused;//是否暂停
@property (atomic, assign) BOOL isDiscount;//是否中断
@property (atomic, assign) CMTime startTime;//开始录制的时间
@property (atomic, assign) double currentRecordTime;//当前录制时间
@property (atomic, assign) CMTime _timeOffset;//录制的偏移CMTime
@property (atomic, assign) CMTime _lastVideo;//记录上一次视频数据文件的CMTime
@property (atomic, assign) CMTime _lastAudio;//记录上一次音频数据文件的CMTime
@property (atomic, assign) int _channels;//音频通道
@property (atomic, assign) Float64 _samplerate;//音频采样率
@property (atomic, assign) NSUInteger witdh;/**捕获视频的宽*/
@property (atomic, assign) NSUInteger height;/**捕获视频的高*/
@property (atomic, assign) SystemCaptureType captureType;//捕捉类型

@end

@implementation CCSystemCapture

- (instancetype)initWithType:(SystemCaptureType)type {
    self = [super init];
    if (self) {
        _captureType = type;
    }
    return self;
}

//MARK:- Control start/stop capture or change camera
- (void)sessionRunning{
    if (![self.captureSession isRunning]) {
        //使用同步会损耗时间，故用异步
        dispatch_async(self.captureQueue, ^{
            [self.captureSession startRunning];
        });
    }
}
- (void)sessionStop{
    if ([self.captureSession isRunning]) {
        //异步停止运行
        dispatch_async(self.captureQueue, ^{
            [self.captureSession stopRunning];
        });
        
    }
    
}


//MARK:- 准备捕获
- (void)prepare {
    
    
}

-(void)updateFps:(NSInteger) fps{
    //获取当前capture设备
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    //遍历所有设备（前后摄像头）
    for (AVCaptureDevice *vDevice in videoDevices) {
        //获取当前支持的最大fps
        float maxRate = [(AVFrameRateRange *)[vDevice.activeFormat.videoSupportedFrameRateRanges objectAtIndex:0] maxFrameRate];
        //如果想要设置的fps小于或等于做大fps，就进行修改
        if (maxRate >= fps) {
            //实际修改fps的代码
            if ([vDevice lockForConfiguration:NULL]) {
                vDevice.activeVideoMinFrameDuration = CMTimeMake(10, (int)(fps * 10));
                vDevice.activeVideoMaxFrameDuration = vDevice.activeVideoMinFrameDuration;
                [vDevice unlockForConfiguration];
            }
        }
    }
}


//准备捕获(视频/音频)
- (void)prepareWithPreviewSize:(CGSize)size {
    
    self.previewLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    /**设置分辨率**/
    //    [self setVideoPreset];
    
    //设置视频录制的方向
    self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
}


#pragma mark-init Audio/video
- (void)setupAudio{
    
}

- (void)setupVideo{
    
}


//MARK:- 输出代理
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    if (_delegate && [_delegate respondsToSelector:@selector(captureOutput:didOutputSampleBuffer:fromConnection:)]) {
        [_delegate captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
    }
}

//MARK:- 懒加载
/**设置分辨率**/
- (void)setVideoPreset{
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080])  {
        _captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
        _witdh = 1080; _height = 1920;
    }else if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
        _witdh = 720; _height = 1280;
    }else{
        _captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        _witdh = 480; _height = 640;
    }
    
}
/********************公共**********/
- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        
        //设置分辨率
//        [self setVideoPreset];
        
        switch (_captureType) {
            case SystemCaptureTypeVideo:
            {
                //添加视频输入
                if ([_captureSession canAddInput:self.videoInput]) {
                    [_captureSession addInput:self.videoInput];
                }
                
                //添加视频输出
                if ([_captureSession canAddOutput:self.videoOutput]) {
                    [_captureSession addOutput:self.videoOutput];
                }
                
                //添加音频输入
                if ([_captureSession canAddInput:self.audioInput]) {
                    [_captureSession addInput:self.audioInput];
                }
                
                //添加音频输出
                if ([_captureSession canAddOutput:self.audioOutput]) {
                    [_captureSession addOutput:self.audioOutput];
                }
            }
                break;
            case SystemCaptureTypeAudio:
            {
                //添加音频输入
                if ([_captureSession canAddInput:self.audioInput]) {
                    [_captureSession addInput:self.audioInput];
                }
                
                //添加音频输出
                if ([_captureSession canAddOutput:self.audioOutput]) {
                    [_captureSession addOutput:self.audioOutput];
                }
            }
                break;
            case SystemCaptureTypeStillImage:
            {
                //添加视频输入
                if ([_captureSession canAddInput:self.videoInput]) {
                    [_captureSession addInput:self.videoInput];
                }
                
                //添加图片输出
                if ([_captureSession canAddOutput:self.imageOutPut]) {
                    [_captureSession addOutput:self.imageOutPut];
                }
            }
                break;
            case SystemCaptureTypeMovie:
            {
                //添加视频输入
                if ([_captureSession canAddInput:self.videoInput]) {
                    [_captureSession addInput:self.videoInput];
                }
                
                //添加影片输出
                if ([_captureSession canAddOutput:self.movieOutput]) {
                    [_captureSession addOutput:self.movieOutput];
                }
            }
                break;
            default:
                break;
        }
        
        
        
    }
    return _captureSession;
}
- (dispatch_queue_t)captureQueue{
    if (!_captureQueue) {
        _captureQueue = dispatch_queue_create("Capture Queue", DISPATCH_QUEUE_SERIAL);
    }
    return _captureQueue;
}

/********************音频相关**********/
- (AVCaptureDeviceInput *)audioInput
{
    if (!_audioInput) {
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error;
        _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        if (error) {
            NSLog(@"获取麦克风失败");
        }
    }
    
    return _audioInput;
}

- (AVCaptureAudioDataOutput *)audioOutput
{
    if (!_audioOutput) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc]init];
        [_audioOutput setSampleBufferDelegate:self queue:self.captureQueue];
    }
    
    return _audioOutput;
}

- (AVCaptureConnection *)audioConnection
{
    if (!_audioConnection) {
        _audioConnection = [self.audioOutput connectionWithMediaType:AVMediaTypeAudio];
    }
    
    return _audioConnection;
}
/********************视频相关**********/
- (AVCaptureDeviceInput *)videoInput
{
    if (!_videoInput) {
        NSError *error;
        //        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDevice *videoDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
        
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (error) {
            NSLog(@"获取默认摄像头失败");
        }
    }
    
    return _videoInput;
}

- (AVCaptureVideoDataOutput *)videoOutput
{
    if (!_videoOutput) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc]init];
        [_videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
        _videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                      nil];
    }
    
    return _videoOutput;
}

- (AVCaptureConnection *)videoConnection
{
    if (!_videoConnection) {
        _videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    }
    
    return _videoConnection;
}

- (AVCaptureMovieFileOutput *)movieOutput
{
    if (!_movieOutput) {
        _movieOutput = [[AVCaptureMovieFileOutput alloc]init];
    }
    
    return _movieOutput;
}
//用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
        
        AVCaptureDeviceDiscoverySession *deviceSession = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
        NSArray *devices  = deviceSession.devices;
        for (AVCaptureDevice *device in devices) {
            if ([device position] == position) {
                return device;
            }
        }
        return nil;
    } else {
        
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == position)
            {
                return device;
            }
        }
        return nil;
    }
}

/********************预览层**********/

- (UIView *)preview{
    if (!_preview) {
        _preview = [[UIView alloc] init];
    }
    return _preview;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.preview.layer addSublayer:_previewLayer];
    }
    
    return _previewLayer;
}

/********************图片捕捉**********/
- (AVCaptureStillImageOutput *)imageOutPut
{
    if (!_imageOutPut) {
        _imageOutPut = [[AVCaptureStillImageOutput alloc]init];
        //        _imageOutPut.outputSettings = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    }
    
    return _imageOutPut;
}

//MARK:- 切换摄像头
-(void)switchCamera{
    
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
        
        AVCaptureDeviceDiscoverySession *deviceSession = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:0];
        NSArray *devices  = deviceSession.devices;
        if (devices.count < 2) {
            NSLog(@"无可切换的输入设备");
            return;
        }
        
    } else {
        
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        if (devices.count < 2) {
            NSLog(@"无可切换的输入设备");
            return;
        }
        
    }
    
    AVCaptureDeviceInput *switchInput;
    if (self.videoInput.device.position == AVCaptureDevicePositionBack)
    {
        //切换至前摄像头
        AVCaptureDevice *frontCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        switchInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:nil];
        
    }else
    {
        //切换至后摄像头
        AVCaptureDevice *backCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        switchInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
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

- (void)changeCameraAnimation {
    CATransition *changeAnimation = [CATransition animation];
    //    changeAnimation.delegate = self;
    changeAnimation.duration = 0.66;
    changeAnimation.type = @"oglFlip";
    //    changeAnimation.type = kCATransitionMoveIn;
    
    changeAnimation.subtype = kCATransitionFromRight;
    changeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.previewLayer addAnimation:changeAnimation forKey:@"changeAnimation"];
}

//- (void)animationDidStart:(CAAnimation *)anim {
//
//   [self startSessionRunning];
//}

//MARK:- 调整焦距&曝光
- (void)focusAtPoint:(CGPoint)point
{
//    CGSize size = [UIScreen mainScreen].bounds.size;
//     focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
//    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    
    AVCaptureDevice *device = self.videoInput.device;
    NSError *error;
    
    if ([device lockForConfiguration:&error]) {
        
        if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
        }
        
        [device unlockForConfiguration];
    }
    
}

- (void)exposeAtPoint:(CGPoint)point
{
    AVCaptureDevice *device = self.videoInput.device;
    NSError *error;
    
    if ([device lockForConfiguration:&error]) {
        
        if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [device setExposurePointOfInterest:point];
            [device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [device unlockForConfiguration];
    }
}

- (void)resetFocusAndExposureModes
{
    AVCaptureDevice *device = self.videoInput.device;
    NSError *error;
    
    //是否支持对焦兴趣点 和 是否支持持续自动对焦模式
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus];
    
    //是否可重置曝光度
    BOOL canResetExposure = [device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure];
    
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);
    if ([device lockForConfiguration:&error]) {
        
        //焦点可设
        if (canResetFocus) {
            device.focusPointOfInterest = centerPoint;
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        
        //曝光度可设
        if (canResetExposure) {
            device.exposurePointOfInterest = centerPoint;
            device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        }
        
        [device unlockForConfiguration];
    }
}

//设置平滑对焦模式，即减慢摄像头对焦速度，当用户移动拍摄时，摄像头会尝试快速自动对焦
- (void)setSmoothAutoFocus
{
    AVCaptureDevice *device = self.videoInput.device;
    NSError *error;
    
    if ([device lockForConfiguration:&error]) {
        
        if (device.isSmoothAutoFocusSupported) {
            device.smoothAutoFocusEnabled = true;
        }
        
        [device unlockForConfiguration];
    }
}

//MARK:- 调整闪光灯&手电筒模式&白平衡
//设置手电筒模式
- (void)setTorchModel:(AVCaptureTorchMode)torchModel
{
    AVCaptureDevice *device = self.videoInput.device;
    
    if (device.hasTorch && [device isTorchModeSupported:torchModel]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = torchModel;
            [device unlockForConfiguration];
        }
    }
}

//设置闪光灯模式
- (void)setFlashMode:(AVCaptureFlashMode)flashModel
{
    AVCaptureDevice *device = self.videoInput.device;
    
    if (device.hasFlash && [device isFlashModeSupported:flashModel]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.flashMode = flashModel;
            [device unlockForConfiguration];
        }
    }
}

//设置自动白平衡
- (void)setWhiteBalance
{
    AVCaptureDevice *device = self.videoInput.device;
    
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
            [device unlockForConfiguration];
        }
    }
}

//MARK:- 捕捉静态图片
- (void)captureStillImage
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __weak typeof(self) weakSelf = self;
        
        AVCaptureConnection * stillImageConnection = [weakSelf.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
        if (stillImageConnection ==  nil) {
            return;
        }
        
        //如果横向拍摄，需要调整拍摄方向
        if (stillImageConnection.isVideoOrientationSupported) {
            stillImageConnection.videoOrientation = [self currentVideoOrientation];
        }
        
        //        //消除取图片时的声音。
        //        static SystemSoundID soundID = 0;
        //        if (soundID == 0) {
        //            NSString *path = [[NSBundle mainBundle] pathForResource:@"photoShutter" ofType:@"caf"];
        //            NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        //            AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        //        }
        //        AudioServicesPlaySystemSound(soundID);
        
        
        [weakSelf.imageOutPut captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            if (imageDataSampleBuffer == nil) {
                return;
            }
            
            NSData *imageData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            if ([self.delegate respondsToSelector:@selector(captureOutput:captureStillImage:)]) {
                [self.delegate captureOutput:weakSelf.imageOutPut captureStillImage:imageData];
            }
            
        }];
    });
}

//获取方向
- (AVCaptureVideoOrientation)currentVideoOrientation
{
    AVCaptureVideoOrientation orientation;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    return orientation;
}

//MARK:- movie
- (void)startMovieRecording
{
    if (self.movieOutput.isRecording) {
        return;
    }
    
    
    AVCaptureConnection *movieConnection = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (movieConnection.isVideoOrientationSupported) {
        movieConnection.videoOrientation = [self currentVideoOrientation];
    }
    
    //判断是否支持视频稳定
    if (movieConnection.isVideoStabilizationSupported) {
        movieConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    }
    
    //设置平滑对焦模式，即减慢摄像头对焦速度，当用户移动拍摄时，摄像头会尝试快速自动对焦
    [self setSmoothAutoFocus];
    
    [movieConnection setVideoScaleAndCropFactor:1.0];
    
    [self.movieOutput startRecordingToOutputFileURL:[self uniqueURL] recordingDelegate:self];
    
    _isRecording = true;
    
}

- (void)stopMovieRecording
{
    if (self.movieOutput.isRecording) {
        [self.movieOutput stopRecording];
         _isRecording = false;
    }
}

- (CMTime)movieRecordDuration
{
    return self.movieOutput.recordedDuration;
}
// AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    if (_delegate && [_delegate respondsToSelector:@selector(captureOutput:didStartRecordingToOutputFileAtURL:fromConnections:)]) {
        [_delegate captureOutput:captureOutput didStartRecordingToOutputFileAtURL:fileURL fromConnections:connections];
    }
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    
    NSLog(@"url = %@ ,recodeTime: = %f s, size: %lld MB", outputFileURL, CMTimeGetSeconds(captureOutput.recordedDuration), captureOutput.recordedFileSize / 1024/1024);
    if (_delegate && [_delegate respondsToSelector:@selector(captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:)]) {
        [_delegate captureOutput:captureOutput didFinishRecordingToOutputFileAtURL:outputFileURL fromConnections:connections error:error];
    }
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didResumeRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
}

//写入地址
- (NSURL *)uniqueURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [[fileManager temporaryDirectory] path];
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"movie.mov"];
    
    return [NSURL fileURLWithPath:filePath];
}


//MARK:- 销毁会话
- (void)dealloc{
    NSLog(@"capture销毁。。。。");
    [self destroyCaptureSession];
}

-(void) destroyCaptureSession{
    if (self.captureSession) {
        if (_captureType == SystemCaptureTypeAudio) {
            [self.captureSession removeInput:self.audioInput];
            [self.captureSession removeOutput:self.audioOutput];
        }else if (_captureType == SystemCaptureTypeStillImage) {
            [self.captureSession removeInput:self.videoInput];
            [self.captureSession removeOutput:self.videoOutput];
        }else if (_captureType == SystemCaptureTypeVideo) {
            [self.captureSession removeInput:self.audioInput];
            [self.captureSession removeOutput:self.audioOutput];
            [self.captureSession removeInput:self.videoInput];
            [self.captureSession removeOutput:self.videoOutput];
        }else if (_captureType == SystemCaptureTypeMovie){
            [self.captureSession removeInput:self.videoInput];
            [self.captureSession removeOutput:self.movieOutput];
        }
    }
    self.captureSession = nil;
}

//MARK:- 授权
/**
 *  麦克风授权
 *  0 ：未授权 1:已授权 -1：拒绝
 */
+ (int)checkMicrophoneAuthor{
    int result = 0;
    //麦克风
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    switch (permissionStatus) {
        case AVAudioSessionRecordPermissionUndetermined:
            //    请求授权
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            }];
            result = 0;
            break;
        case AVAudioSessionRecordPermissionDenied://拒绝
            result = -1;
            break;
        case AVAudioSessionRecordPermissionGranted://允许
            result = 1;
            break;
        default:
            break;
    }
    return result;
    
    
}

/**
 *  摄像头授权
 *  0 ：未授权 1:已授权 -1：拒绝
 */
+ (int)checkCameraAuthor{
    int result = 0;
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoStatus) {
        case AVAuthorizationStatusNotDetermined://第一次
            //    请求授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
            }];
            break;
        case AVAuthorizationStatusAuthorized://已授权
            result = 1;
            break;
        default:
            result = -1;
            break;
    }
    return result;
    
}

@end

