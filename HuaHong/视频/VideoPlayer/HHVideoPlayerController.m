//
//  HHVideoPlayerController.m
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import "HHVideoPlayerController.h"
#import "HHVideoPlayManager.h"

@interface HHVideoPlayerController ()
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UIButton *rewindBtn;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *fastForwardBtn;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (nonatomic,strong) HHVideoPlayManager *playManager;
@end

@implementation HHVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playManager = [HHVideoPlayManager defaultManager];
    self.playManager.URL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    [self.playManager addPlayerLayerTo:self.playView];
    
    __weak typeof(self) weakSelf = self;
    
    //总时长
    [self.playManager setPlayDuration:^(BOOL hasValidDuration, float totalTime) {
        
        weakSelf.slider.maximumValue = totalTime;

        int minutes = (int)trunc(totalTime / 60);
        int seconds = (int)trunc(totalTime) - minutes * 60;
        weakSelf.durationLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    }];
    
    //当前播放时长
    [self.playManager setPlaycurrentTime:^(float currentTime) {
        
        weakSelf.slider.value = currentTime;
        
        int minutes = (int)trunc(currentTime / 60);
        int seconds = (int)trunc(currentTime) - minutes * 60;
        weakSelf.startTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];

    }];
    
    //播放速率
    [self.playManager setPlayRate:^(float rate) {
        NSString *btnTitle = (rate == 1.0)?@"暂停":@"播放";
        [weakSelf.playOrPauseBtn setTitle:btnTitle forState:UIControlStateNormal];
    }];
}

//快退
- (IBAction)rewindAction:(id)sender
{
    self.playManager.rate = MAX(self.playManager.rate-2.0, -2.0);
}

//快进
- (IBAction)fastForwardAction:(id)sender
{
   self.playManager.rate = MAX(self.playManager.rate+2.0, 2.0);
}

//播放/暂停
- (IBAction)playOrPauseAction:(UIButton *)sender
{
    if (self.playManager.rate != 1.0) {
        [self.playManager play];
//        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }else
    {
        [self.playManager pause];
//        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }
}

//进度条
- (IBAction)sliderAction:(UISlider *)sender
{
    [self.playManager changeTimeSlider:sender.value];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.playManager removePlayer];
}
@end
