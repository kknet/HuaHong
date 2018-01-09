//
//  VideoBottomView.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/6.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "VideoBottomView.h"
@interface VideoBottomView()

//展示视频首帧缩略图，播放按钮
@property (nonatomic, strong) UIButton *videoThumb;

//开始录制和停止按钮
@property (nonatomic, strong) UIButton *recordBtn;

//时间
@property (nonatomic, strong) UILabel *timeLabel;

//视觉效果图 (覆盖整个view，有毛玻璃效果)
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@end

@implementation VideoBottomView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.visualEffectView];
        [self.visualEffectView.contentView addSubview:self.videoThumb];
        [self.visualEffectView.contentView addSubview:self.recordBtn];
        [self.visualEffectView.contentView addSubview:self.timeLabel];
    }
    
    return self;
}

-(void)eventHandler:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(VideoBottomViewClickHandler:)]) {
        [self.delegate VideoBottomViewClickHandler:sender.tag-2017];
    }
}
#pragma mark - Lazy Load

- (UIButton *)videoThumb
{
    if (_videoThumb == nil) {
        _videoThumb = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoThumb setBackgroundColor:[UIColor blackColor]];
        _videoThumb.tag = 2017 + VideoBottomViewClickTypePlay;
        [_videoThumb addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        _videoThumb.frame = CGRectMake(40, (self.visualEffectView.contentView.height-50)/2, 50, 50);
    }
    return _videoThumb;
}

- (UIButton *)recordBtn
{
    if (_recordBtn == nil) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageNamed:@"editor_video_start_normal"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"editor_video_start_selected"] forState:UIControlStateSelected];
        _recordBtn.tag = 2017 + VideoBottomViewClickTypeRecord;
        [_recordBtn addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        _recordBtn.frame = CGRectMake(0, 0, 60, 60);
        _recordBtn.center = self.visualEffectView.contentView.center;
        
    }
    return _recordBtn;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12.];
        _timeLabel.layer.cornerRadius = 5;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.recordBtn.top);
    }
    return _timeLabel;
}

- (UIVisualEffectView *)visualEffectView
{
    if (_visualEffectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
        _visualEffectView.frame = self.bounds;
        
    }
    return _visualEffectView;
}

-(void)configTimeLabel:(CGFloat)second
{
    NSInteger time = ceil(second);//ceil 取整函数
    NSInteger seconds = time%60;
    NSInteger minute = time/60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",(long)minute,(long)seconds];
}

-(void)configVideoThumb:(UIImage *)thumbImage
{
    [self.videoThumb setImage:thumbImage forState:UIControlStateNormal];

}
@end
