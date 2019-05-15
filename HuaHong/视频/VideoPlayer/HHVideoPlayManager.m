//
//  VideoPlayerManager.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHVideoPlayManager.h"

@interface HHVideoPlayManager ()
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic,assign) CGSize playSize;
@end

@implementation HHVideoPlayManager
{
    id<NSObject> _timeObserverToken;
}
+(instancetype)defaultManager
{
    static HHVideoPlayManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HHVideoPlayManager alloc]init];
    });
    
    return instance;
}
- (void)play
{
    if (CMTIME_COMPARE_INLINE(self.currentTime, ==, self.duration)) {
        
        self.currentTime = kCMTimeZero;
    }
    
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    
    return _playerItem;
}

- (void)playbackFinished:(NSNotification *)noti
{
    self.currentTime = kCMTimeZero;
    
    if (_PlayFinished) {
        _PlayFinished();
    }
}

- (AVPlayer *)player
{
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        
        [self addObserver:self forKeyPath:@"player.currentItem.duration" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
        [self addObserver:self forKeyPath:@"player.rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
        [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
        
        __weak typeof(self) weakSelf = self;
        _timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:
                              ^(CMTime time) {
          if (weakSelf.PlaycurrentTime) {
              weakSelf.PlaycurrentTime(CMTimeGetSeconds(time));
          }
                              }];
    }
    
    return _player;
}
- (AVPlayerLayer *)playerLayer
{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = CGRectMake(0, 0, _playSize.width, _playSize.height);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
    }
    
    return _playerLayer;
}

- (CMTime)currentTime {
    return self.player.currentTime;
}
- (void)setCurrentTime:(CMTime)newCurrentTime {
    [self.player seekToTime:newCurrentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (CMTime)duration {
    return self.player.currentItem ? self.player.currentItem.duration : kCMTimeZero;
}

- (float)rate {
    return self.player.rate;
}
- (void)setRate:(float)newRate {
    self.player.rate = newRate;
}

//- (void)setPlayerItem:(AVPlayerItem *)newPlayerItem {
//    if (_playerItem != newPlayerItem) {
//
//        _playerItem = newPlayerItem;
//
//        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
//    }
//}

/** 将在哪个view上播放 */
- (void)addPlayerLayerTo:(UIView *)view
{
    self.playSize = view.bounds.size;
    [view.layer insertSublayer:self.playerLayer atIndex:0];
}

- (void)removePlayer
{
    [self.player pause];
    _playerItem = nil;
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    if (_timeObserverToken) {
        [self.player removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }
    
    
    [self removeObserver:self forKeyPath:@"player.currentItem.duration" context:nil];
    [self removeObserver:self forKeyPath:@"player.rate" context:nil];
    [self removeObserver:self forKeyPath:@"player.currentItem.status" context:nil];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"player.currentItem.duration"]) {
        
        
        NSValue *newDurationAsValue = change[NSKeyValueChangeNewKey];
        CMTime newDuration = [newDurationAsValue isKindOfClass:[NSValue class]] ? newDurationAsValue.CMTimeValue : kCMTimeZero;
        BOOL hasValidDuration = CMTIME_IS_NUMERIC(newDuration) && newDuration.value != 0;
        double newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0;
        
//        float currentTime = hasValidDuration ? CMTimeGetSeconds(self.currentTime) : 0.0;
        if (self.PlayDuration) {
            self.PlayDuration(hasValidDuration, newDurationSeconds);
        }
//        self.timeSlider.maximumValue = newDurationSeconds;
//        self.timeSlider.value = hasValidDuration ? CMTimeGetSeconds(self.currentTime) : 0.0;
//        self.rewindButton.enabled = hasValidDuration;
//        self.playPauseButton.enabled = hasValidDuration;
//        self.fastForwardButton.enabled = hasValidDuration;
//        self.timeSlider.enabled = hasValidDuration;
//        self.startTimeLabel.enabled = hasValidDuration;
//        self.durationLabel.enabled = hasValidDuration;
//        int wholeMinutes = (int)trunc(newDurationSeconds / 60);
//        self.durationLabel.text = [NSString stringWithFormat:@"%d:%02d", wholeMinutes, (int)trunc(newDurationSeconds) - wholeMinutes * 60];
        
    }else if ([keyPath isEqualToString:@"player.rate"]) {
        
        double newRate = [change[NSKeyValueChangeNewKey] floatValue];
        if (self.PlayRate) {
            self.PlayRate(newRate);
        }
//        UIImage *buttonImage = (newRate == 1.0) ? [UIImage imageNamed:@"PauseButton"] : [UIImage imageNamed:@"PlayButton"];
//        [self.playPauseButton setImage:buttonImage forState:UIControlStateNormal];
        
    }else if ([keyPath isEqualToString:@"player.currentItem.status"]) {
        
        NSNumber *newStatusAsNumber = change[NSKeyValueChangeNewKey];
        AVPlayerItemStatus newStatus = [newStatusAsNumber isKindOfClass:[NSNumber class]] ? newStatusAsNumber.integerValue : AVPlayerItemStatusUnknown;
        
        if (newStatus == AVPlayerItemStatusFailed)
        {
            NSLog(@"播放失败");
            
        }else if (newStatus == AVPlayerItemStatusReadyToPlay)
        {
            [self.player play];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//监听属性值的相互影响
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"duration"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.duration" ]];
    } else if ([key isEqualToString:@"currentTime"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.currentTime" ]];
    } else if ([key isEqualToString:@"rate"]) {
        return [NSSet setWithArray:@[ @"player.rate" ]];
    } else {
        return [super keyPathsForValuesAffectingValueForKey:key];
    }
}

//- (IBAction)playPauseButtonWasPressed:(UIButton *)sender {
//    if (self.player.rate != 1.0) {
//
//        if (CMTIME_COMPARE_INLINE(self.currentTime, ==, self.duration)) {
//
//            self.currentTime = kCMTimeZero;
//        }
//        [self.player play];
//    } else {
//
//        [self.player pause];
//    }
//}

- (void)rewind
{
//    self.rate = MAX(self.player.rate - 2.0, -2.0);
    Float64 currentTime = CMTimeGetSeconds(self.currentTime);
    currentTime -= 5;
    self.currentTime = CMTimeMakeWithSeconds(currentTime, 1000);
}

- (void)fastForward
{
//    self.rate = MIN(self.player.rate + 2.0, 2.0);
    
    Float64 currentTime = CMTimeGetSeconds(self.currentTime);
    currentTime += 5;
    self.currentTime = CMTimeMakeWithSeconds(currentTime, 1000);

}

- (void)changeTimeSlider:(float)value {
    self.currentTime = CMTimeMakeWithSeconds(value, 1000);
}
@end
