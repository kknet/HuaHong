//
//  HHPlayerViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHPlayerViewController.h"
#import <AVKit/AVKit.h>

@interface HHPlayerViewController ()
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@end

@implementation HHPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)playVideo_AVPlayer:(NSURL *)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.view.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:self.playerLayer];
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)playVideo_AVPlayerViewController:(NSURL *)url
{
    AVPlayerViewController *pvc = [AVPlayerViewController new];
    pvc.player = [AVPlayer playerWithURL:url];
    [pvc.player play];
    [self presentViewController:pvc animated:YES completion:nil];
    
    //自定义播放器大小
    pvc.view.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 300);
    [self.view addSubview:pvc.view];
}
- (void)playbackFinished:(NSNotification *)noti
{
    NSLog(@"视频文件播放完了");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
