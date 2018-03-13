//
//  BaseVideoController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "BaseVideoController.h"
#import "HHPlayerViewController.h"

@interface BaseVideoController()
/**
 *  记录录制时间
 */
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation BaseVideoController

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    
}

#pragma mark - Lazy Load
- (VideoTopView *)topView
{
    if (_topView == nil) {
        _topView = [[VideoTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _topView.delegate = self;
    }
    return _topView;
}

- (VideoBottomView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[VideoBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
        _bottomView.backgroundColor = [UIColor lightGrayColor];
        _bottomView.delegate = self;
        [_bottomView configTimeLabel:0];
        
    }
    return _bottomView;
}

/**
 开启计时器
 */
-(void)timerFired
{
    _timeLengh = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRecord) userInfo:nil repeats:YES];
}

-(void)timerRecord
{
    _timeLengh++;
    
    [self.bottomView configTimeLabel:_timeLengh];
    
}

/**
 停止计时器
 */
- (void)timerStop{
    
    if ([self.timer isValid]) {
        
        [self.timer invalidate];
        self.timer = nil;
        _timeLengh = 0;
    }
}
#pragma mark - VideoTopViewDelegate
-(void)VideoTopViewClickHandler:(VideoTopViewClickType)type
{
    switch (type) {
        case VideoTopViewClickTypeClose:
            [self back];
            break;
        case VideoTopViewClickTypeFlash:
            [self switchFlashLight];
            break;
        case VideoTopViewClickTypeSwitchCamera:
            [self changeCamera];
            break;
        default:
            break;
    }
}


#pragma mark - VideoBottomViewDelegate
-(void)VideoBottomViewClickHandler:(VideoBottomViewClickType)type
{
    switch (type) {
        case VideoBottomViewClickTypeRecord:
            [self begainrecord];
            break;
        case VideoBottomViewClickTypePlay:
        {
            if (self.bottomView.lastVideoPath)
            {
                [self playVideo:self.bottomView.lastVideoPath];
            }
            
        }
            break;
        default:
            break;
    }
}



- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)switchFlashLight
{
    [HHVideoManager switchFlashLight];
}

- (void)changeCamera
{
//    VideoRecorder *recorder = [[VideoRecorder alloc]init];
//    [recorder switchCamera];
}

-(void)playVideo:(NSString *)path
{
    HHPlayerViewController *playVc = [[HHPlayerViewController alloc] init];
    [playVc playVideo_AVPlayerViewController:[NSURL fileURLWithPath:path]];
    [self presentViewController:playVc animated:YES completion:nil];
}

-(void)begainrecord
{
    
}
@end

