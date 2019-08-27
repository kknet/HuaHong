//
//  CustomVideoController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "CustomVideoController.h"
#import <VideoToolbox/VideoToolbox.h>

@interface CustomVideoController ()<VideoRecordDelegate>
@property (nonatomic, strong) VideoRecorder *recorder;

@end

@implementation CustomVideoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (![HHVideoManager cameraAuthStatus]) {
        
        [super back];
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.recorder startRunning];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.recorder stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//开始和停止录制事件
- (void)recordAction {
    
    if (![HHVideoManager isCameraAvailable] && ![HHVideoManager cameraSupportShootingVideos]) {
        return;
    }
    
    
    if (!self.recorder.isRecording)
    {
        [self initVideotoolBox];
        [self.recorder startRecording];
        self.topView.hidden = YES;
    }else
    {
        
        [self.recorder stopRecordingCompletion:^(NSURL *outputURL) {
            
            CGFloat videoLenth = [HHVideoManager getVideoLength:outputURL];
            CGFloat videoSize = [HHVideoManager getFileSize:[outputURL path]];
            NSLog(@"videoLenth:%.2fs",videoLenth);
            NSLog(@"videoSize:%.2fM",videoSize);
            
            
            __weak typeof(self) weakSelf = self;
            weakSelf.topView.hidden = NO;
            
            [HHVideoManager saveVideoPath:outputURL Watermark:@"水印:新华社北京3月13日电（记者叶昊鸣）记者13日从应急管理部了解到，财政部、应急管理部当日向青海省下拨中央自然灾害救灾资金1亿元，主要用于支持做好青海省玉树、果洛等地严重雪灾受灾群众救助工作，保障受灾群众基本生活。" complete:^(NSURL *outputURL) {
                NSLog(@"添加水印完成");
                weakSelf.bottomView.lastVideoPath = [outputURL path];
                
            //获取视频第一帧的图片
            [self.bottomView configVideoThumb:[UIImage getThumbnail:outputURL]];
            
            //保存到相册
            [HHVideoManager saveToPhotoLibrary:outputURL];
                
            }];
            
            
            
            
            
        }];
    }
}

#pragma mark - Lazy Load
- (VideoRecorder *)recorder
{
    if (_recorder == nil) {
        _recorder = [[VideoRecorder alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.view.width, self.bottomView.top-self.topView.bottom) SuperView:self.view];
//        _recorder.maxVideoDuration = NSIntegerMax;
        _recorder.delegate = self;
//        _recorder.capture.frame = self.view.bounds;
        _recorder.maxVideoDuration = 10;
//        [self.view.layer insertSublayer:_recorder.previewLayer atIndex:0];
    }
    return _recorder;
}

#pragma mark - VideoRecordDelegate
- (void)recordProgress:(CGFloat)progress Duration:(double)duration
{
    NSLog(@"maxVideoDuration:%f",progress * self.recorder.maxVideoDuration);
    
    [self.bottomView configTimeLabel:duration];
}


#pragma mark  - 重写父类方法
-(void)begainrecord
{
    [self recordAction];
}


#pragma mark - initVideotoolBox
- (void)initVideotoolBox
{
    
}
@end
