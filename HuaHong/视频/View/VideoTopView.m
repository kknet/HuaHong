//
//  VideoTopView.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/6.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "VideoTopView.h"

@interface VideoTopView()
//关闭
@property (nonatomic, strong) UIButton *closeBtn;

//闪光灯
@property (nonatomic, strong) UIButton *flashBtn;

//切换摄像头
@property (nonatomic, strong) UIButton *switchCamera;

//视觉效果图 (覆盖整个view，有毛玻璃效果)
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end
@implementation VideoTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self addSubview:self.visualEffectView];
        [self.visualEffectView.contentView addSubview:self.closeBtn];
        [self.visualEffectView.contentView addSubview:self.flashBtn];
        [self.visualEffectView.contentView addSubview:self.switchCamera];
    }
    
    return self;
}

-(void)eventHandler:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(VideoTopViewClickHandler:)]) {
        [self.delegate VideoTopViewClickHandler:sender.tag-2017];
    }
}
#pragma mark - Lazy Load

- (UIButton *)closeBtn
{
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeBtn.tag = 2017 + VideoTopViewClickTypeClose;
        [_closeBtn addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.frame = CGRectMake(0, 0, kScreenWidth/3.0, 64);
    }
    return _closeBtn;
}

- (UIButton *)flashBtn
{
    if (_flashBtn == nil) {
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashBtn setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
        _flashBtn.tag = 2017 + VideoTopViewClickTypeFlash;
        [_flashBtn addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        _flashBtn.frame = CGRectMake(self.closeBtn.right, 0, kScreenWidth/3.0, 64);

    }
    return _flashBtn;
}

- (UIButton *)switchCamera
{
    if (_switchCamera == nil) {
        _switchCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCamera setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
        _switchCamera.tag = 2017 + VideoTopViewClickTypeSwitchCamera;
        [_switchCamera addTarget:self action:@selector(eventHandler:) forControlEvents:UIControlEventTouchUpInside];
        _switchCamera.frame = CGRectMake(self.flashBtn.right, 0, kScreenWidth/3.0, 64);

    }
    return _switchCamera;
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

@end
