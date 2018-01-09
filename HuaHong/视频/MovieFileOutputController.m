//
//  MovieFileOutputController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "MovieFileOutputController.h"

@interface MovieFileOutputController ()

/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;

/**
 *  视频输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;

/**
 *  声音输入
 */
@property (nonatomic, strong) AVCaptureDeviceInput* audioInput;

/**
 *  视频输出流
 */
@property(nonatomic,strong)AVCaptureMovieFileOutput *movieFileOutput;

/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;


//@property (strong, nonatomic) AVCaptureDeviceInput       *backCameraInput;//后置摄像头输入
//@property (strong, nonatomic) AVCaptureDeviceInput       *frontCameraInput;//前置摄像头输入

@end

@implementation MovieFileOutputController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.isRecord = NO;
    self.isFront = NO;

    
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
}

//开始和停止录制事件
- (void)recordAction
{
    if (![VideoManager isCameraAvailable] && ![VideoManager cameraSupportShootingVideos]) {
        return;
    }
    
    if (!self.isRecord)
    {
        [self startVideoRecorder];
        
    } else
    {
        
        if ([self.movieFileOutput isRecording])
        {
            
            [self.movieFileOutput stopRecording];
            
        }
        
        
    }
    
    self.isRecord = !self.isRecord;
    
    
}

/**
 开始录音
 */
- (void)startVideoRecorder{
    
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
    
    //开始录制
    if (![self.movieFileOutput isRecording])
    {
        AVCaptureConnection *movieConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        AVCaptureVideoOrientation avcaptureOrientation = AVCaptureVideoOrientationPortrait;
        [movieConnection setVideoOrientation:avcaptureOrientation];
        [movieConnection setVideoScaleAndCropFactor:1.0];
        
        NSURL *url = [NSURL fileURLWithPath:[VideoManager getVideoCachePath]];
        [self.movieFileOutput startRecordingToOutputFileURL:url recordingDelegate:self];
        
        self.topView.hidden = YES;

    }else
    {
        // 停止录制
        [super timerStop];
        [self.movieFileOutput stopRecording];
        

    }
    
}


#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    [super timerFired];
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    
    
    NSLog(@"%s-- url = %@ ,recodeTime: = %f s, size: %lld kb", __func__, outputFileURL, CMTimeGetSeconds(captureOutput.recordedDuration), captureOutput.recordedFileSize / 1024);
    
    
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    
    
    self.bottomView.lastVideoPath = [outputFileURL path];
    
    __weak typeof(self) weakSelf = self;
    [VideoManager movieToImageWithVideoURL:outputFileURL Handler:^(UIImage *movieImage) {
        [weakSelf.bottomView configVideoThumb:movieImage];
    }];
    
    [self timerStop];
    [self.bottomView configTimeLabel:self.timeLengh];
    
    self.topView.hidden = NO;

    
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"didPauseRecordingToOutputFileAtURL");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didResumeRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"didResumeRecordingToOutputFileAtURL");
}

#pragma mark Setter & Getter

-(AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        
        
        _session.sessionPreset = AVCaptureSessionPreset1280x720;
        
        
        if ([_session canAddInput:self.videoInput]) {
            [_session addInput:self.videoInput];
        }
        
        if ([_session canAddInput:self.audioInput]) {
            
            [_session addInput:self.audioInput];
        }
        
        if ([_session canAddOutput:self.movieFileOutput]) {
            
            [_session addOutput:self.movieFileOutput];
        }
        
        
    }
    return _session;
}

-(AVCaptureDeviceInput *)videoInput
{
    if (!_videoInput) {
        NSError *error;

        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

        //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
        [device lockForConfiguration:nil];
        //设置闪光灯为自动
        [device setFlashMode:AVCaptureFlashModeAuto];
        [device unlockForConfiguration];

        _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];

    }
    return _videoInput;
}

-(AVCaptureDeviceInput *)audioInput
{
    if (!_audioInput) {
        _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
    }
    return _audioInput;
}

-(AVCaptureMovieFileOutput *)movieFileOutput
{
    if (!_movieFileOutput) {
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    }
    return _movieFileOutput;
}

-(AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        _previewLayer.frame = self.view.bounds;
    }
    return _previewLayer;
}


#pragma mark  - 重写父类方法
-(void)begainrecord
{
    [self recordAction];
}

-(void)changeCamera
{
    [self switchCamera];
}

//切换前后置摄像头
- (void)switchCamera{
    AVCaptureDevicePosition desiredPosition;
    if (self.isFront){
        desiredPosition = AVCaptureDevicePositionBack;
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        
        if ([device position] == desiredPosition) {
            
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            
            if ([self.previewLayer.session canAddInput:input])
            {
                [self.previewLayer.session addInput:input];
            }
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
     self.isFront = !self.isFront;
}

@end
