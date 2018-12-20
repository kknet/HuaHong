//
//  VideoPlayerManager.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "VideoPlayerManager.h"

@interface VideoPlayerManager ()
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@end

@implementation VideoPlayerManager

+(instancetype)defaultManager
{
    static VideoPlayerManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VideoPlayerManager alloc]init];
    });
    
    return instance;
}
- (void)play
{
    [self.player play];
}
- (void)pause
{
    [self.player pause];
}

- (AVPlayerItem *)playerItem
{
    if (!_playerItem) {
        AVAsset *asset = [AVAsset assetWithURL:_URL];
        _playerItem = [AVPlayerItem playerItemWithAsset:asset];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        
    }
    
    return _playerItem;
}

- (void)playbackFinished:(NSNotification *)noti
{
    NSLog(@"视频播放完了");
    if (_PlayFinished) {
        _PlayFinished();
    }
}

- (AVPlayer *)player
{
    if (!_player) {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    
    return _player;
}
- (AVPlayerLayer *)playerLayer
{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
    }
    
    return _playerLayer;
}

/** 将在哪个view上播放 */
- (void)addPlayerLayerTo:(UIView *)view
{
    [view.layer insertSublayer:self.playerLayer atIndex:0];
}

- (void)removePlayer
{
    _playerItem = nil;
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
