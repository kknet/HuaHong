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
    
    
    if (!self.recorder.isCapturing)
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
            
            
//            WEAKSELF(weakSelf);
            __weak typeof(self) weakSelf = self;
            weakSelf.topView.hidden = NO;
            
            [HHVideoManager saveVideoPath:outputURL Watermark:@"水印:我就第五空间安抚 我发啊发安抚请叫我去哦无奇特跳舞毯问摊位图五给多少关键是给多少都告诉东哥 打过来靳魏坤赶紧离开我就饿了估计未来根据两位个; 文件柜看我今儿个礼物给我各位个我各位个我无功无过 滚动个如果积极认购人东方啊" complete:^(NSURL *outputURL) {
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
        _recorder = [[VideoRecorder alloc] init];
        _recorder.maxVideoDuration = NSIntegerMax;
        _recorder.delegate = self;
        _recorder.previewLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:_recorder.previewLayer atIndex:0];
    }
    return _recorder;
}

#pragma mark - VideoRecordDelegate
- (void)recordProgress:(CGFloat)progress
{
    NSLog(@"maxVideoDuration:%f",progress * self.recorder.maxVideoDuration);
    [self.bottomView configTimeLabel:progress * self.recorder.maxVideoDuration];
}


#pragma mark  - 重写父类方法
-(void)begainrecord
{
    [self recordAction];
}

-(void)changeCamera
{
    [self.recorder switchCamera];
}

#pragma mark - initVideotoolBox
- (void)initVideotoolBox
{
    
}
@end
