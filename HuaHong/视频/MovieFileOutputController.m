//
//  MovieFileOutputController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "MovieFileOutputController.h"
#import "CCSystemCapture.h"

@interface MovieFileOutputController ()<SystemCaptureDelegate>
@property (nonatomic, strong) CCSystemCapture *capture;
@end

@implementation MovieFileOutputController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self.capture startRunning];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self.capture stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _capture = [[CCSystemCapture alloc] initWithType:SystemCaptureTypeMovie];
    CGSize size = self.view.bounds.size;
    [_capture prepareWithPreviewSize:size];  //捕获视频时传入预览层大小
    _capture.preview.frame = self.view.bounds;
    [self.view insertSubview:_capture.preview atIndex:0];
    self.capture.delegate = self;
    
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    [super timerFired];
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    
    NSLog(@"url = %@ ,recodeTime: = %f s, size: %lld MB", outputFileURL, CMTimeGetSeconds(captureOutput.recordedDuration), captureOutput.recordedFileSize / 1024/1024);

    if (self.capture.isRecording) {
        [self.capture stopRunning];
    }
    
    [self timerStop];

    self.bottomView.lastVideoPath = [outputFileURL path];
    
    [self.bottomView configVideoThumb:[UIImage getThumbnail:outputFileURL]];
    
    [self.bottomView configTimeLabel:self.timeLengh];
    
    self.topView.hidden = NO;
    
}

#pragma mark  - 重写父类方法
-(void)begainrecord
{
    if (![HHVideoManager isCameraAvailable] && ![HHVideoManager cameraSupportShootingVideos]) {
        return;
    }
    
    
    //开始录制
    if (!self.capture.isRecording)
    {
        [self.capture startMovieRecording];
        self.topView.hidden = YES;
        
    }else
    {
        // 停止录制
        [super timerStop];
        [self.capture stopMovieRecording];
        
    }
}

-(void)changeCamera
{
    [self.capture switchCamera];
}

-(void)switchFlashLight
{
    [self.capture setTorchModel:AVCaptureTorchModeOn];
}
@end
