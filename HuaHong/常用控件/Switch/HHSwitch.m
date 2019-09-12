//
//  HHSwitch.m
//  HuaHong
//
//  Created by 华宏 on 2018/5/23.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHSwitch.h"

#define HHSwitchHeight    31.0f
#define HHSwitchMinWidth  51.0f
#define HHSwitchKnobSize  28.0f

@interface HHSwitch()

@property (nonatomic, strong) UIView  *onContentView;
@property (nonatomic, strong) UIView  *offContentView;
@property (nonatomic, strong) UIView  *knobView;
@property (nonatomic, strong) UILabel *onLabel;
@property (nonatomic, strong) UILabel *offLabel;

@end

@implementation HHSwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[self roundRect:frame]];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:[self roundRect:bounds]];
    
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[self roundRect:frame]];
    
    [self setNeedsLayout];
}

- (void)setOnText:(NSString *)onText
{
    _onText = onText;
    _onLabel.text = onText;
}

- (void)setOffText:(NSString *)offText
{
    if (_offText != offText) {
        _offText = offText;
        
        _offLabel.text = offText;
    }
}

- (void)setOnTintColor:(UIColor *)onTintColor
{
    if (_onTintColor != onTintColor) {
        _onTintColor = onTintColor;
        
        _onContentView.backgroundColor = onTintColor;
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        
        _offContentView.backgroundColor = tintColor;
    }
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    if (_thumbTintColor != thumbTintColor) {
        _thumbTintColor = thumbTintColor;
        
        _knobView.backgroundColor = _thumbTintColor;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cornerRadius = CGRectGetHeight(self.bounds) / 2.0;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    
    CGFloat margin = (CGRectGetHeight(self.bounds) - HHSwitchKnobSize) / 2.0;
    CGFloat left = (self.isOn)? CGRectGetWidth(self.bounds) - margin - HHSwitchKnobSize : margin;
    
    self.onContentView.hidden = !self.isOn;
    self.offContentView.hidden = self.isOn;
    self.knobView.frame = CGRectMake(left,margin,HHSwitchKnobSize,HHSwitchKnobSize);
    
    CGFloat labelHeight = CGRectGetHeight(self.bounds);
    //    CGFloat lMargin = cornerRadius - (sqrtf(powf(cornerRadius, 2) - powf(labelHeight / 2.0, 2))) + margin;
    
    self.onLabel.frame = CGRectMake(0,0,CGRectGetWidth(self.bounds)  - HHSwitchKnobSize - 2 * margin,labelHeight);
    
    self.offLabel.frame = CGRectMake(HHSwitchKnobSize + 2 * margin,0,CGRectGetWidth(self.bounds) - HHSwitchKnobSize - 2 * margin,labelHeight);
}

- (void)setOn:(BOOL)on
{
    [self setOn:on animated:YES];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (_on == on) {
        return;
    }
    
    _on = on;
    
    if (animated)
    {
        
        CGFloat margin = (CGRectGetHeight(self.bounds) - HHSwitchKnobSize) / 2.0;
        CGFloat left = (self.isOn)? CGRectGetWidth(self.bounds) - margin - HHSwitchKnobSize : margin;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             self.knobView.frame = CGRectMake(left,margin,HHSwitchKnobSize,HHSwitchKnobSize);
                             
                         }completion:^(BOOL finished){
                             
                             self.onContentView.hidden = !self.isOn;
                             self.offContentView.hidden = self.isOn;
                             
                         }];
        
    }else
    {
        [self setNeedsLayout];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Private API

- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _onTintColor = [UIColor colorWithRed:91 / 255.0 green:221 / 255.0 blue:103 / 255.0 alpha:1.0];
    _tintColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    _thumbTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    _textFont = [UIFont systemFontOfSize:18.0f];
    _textColor = [UIColor whiteColor];
    
    _onContentView = [[UIView alloc] initWithFrame:self.bounds];
    _onContentView.backgroundColor = _onTintColor;
    [self addSubview:_onContentView];
    
    _offContentView = [[UIView alloc] initWithFrame:self.bounds];
    _offContentView.backgroundColor = _tintColor;
    [self addSubview:_offContentView];
    
    _knobView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HHSwitchKnobSize, HHSwitchKnobSize)];
    _knobView.backgroundColor = _thumbTintColor;
    _knobView.layer.cornerRadius = HHSwitchKnobSize / 2.0;
    [self addSubview:_knobView];
    
    _onLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _onLabel.backgroundColor = [UIColor clearColor];
    _onLabel.textAlignment = NSTextAlignmentCenter;
    _onLabel.textColor = _textColor;
    _onLabel.font = _textFont;
    _onLabel.text = _onText;
    [_onContentView addSubview:_onLabel];
    
    _offLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _offLabel.backgroundColor = [UIColor clearColor];
    _offLabel.textAlignment = NSTextAlignmentCenter;
    _offLabel.textColor = _textColor;
    _offLabel.font = _textFont;
    _offLabel.text = _offText;
    [_offContentView addSubview:_offLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapGestureRecognizerEvent:)];
    [self addGestureRecognizer:tapGesture];
    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerEvent:)];
//    [self addGestureRecognizer:panGesture];
}

- (CGRect)roundRect:(CGRect)frameOrBounds
{
    CGRect newRect = frameOrBounds;
    newRect.size.height = HHSwitchHeight;
    newRect.size.width = MAX(newRect.size.width, HHSwitchMinWidth);
    return newRect;
}

- (void)tapGestureRecognizerEvent:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self setOn:!self.isOn animated:YES];
    }
}

//- (void)panGestureRecognizerEvent:(UIPanGestureRecognizer *)recognizer
//{
//    CGFloat margin = (CGRectGetHeight(self.bounds) - HHSwitchKnobSize) / 2.0;
//    CGFloat offset = 6.0f;
//
//    switch (recognizer.state) {
//        case UIGestureRecognizerStateBegan:{
//            if (!self.isOn) {
//                [UIView animateWithDuration:0.25
//                                 animations:^{
//                                     self.knobView.frame = CGRectMake(margin,
//                                                                      margin,
//                                                                      HHSwitchKnobSize + offset,
//                                                                      HHSwitchKnobSize);
//                                 }];
//            } else {
//                [UIView animateWithDuration:0.25
//                                 animations:^{
//                                     self.knobView.frame = CGRectMake(CGRectGetWidth(self.bounds) - margin - (HHSwitchKnobSize + offset),
//                                                                      margin,
//                                                                      HHSwitchKnobSize + offset,
//                                                                      HHSwitchKnobSize);
//                                 }];
//            }
//            break;
//        }
//        case UIGestureRecognizerStateCancelled:
//        case UIGestureRecognizerStateFailed: {
//            if (!self.isOn) {
//                [UIView animateWithDuration:0.25
//                                 animations:^{
//                                     self.knobView.frame = CGRectMake(margin,
//                                                                      margin,
//                                                                      HHSwitchKnobSize,
//                                                                      HHSwitchKnobSize);
//                                 }];
//            } else {
//                [UIView animateWithDuration:0.25
//                                 animations:^{
//                                     self.knobView.frame = CGRectMake(CGRectGetWidth(self.bounds) - HHSwitchKnobSize,
//                                                                      margin,
//                                                                      HHSwitchKnobSize,
//                                                                      HHSwitchKnobSize);
//                                 }];
//            }
//            break;
//        }
//
//        case UIGestureRecognizerStateEnded:
//            [self setOn:!self.isOn animated:YES];
//            break;
//
//        case UIGestureRecognizerStatePossible:
//        case UIGestureRecognizerStateChanged:
//            break;
//    }
//}

@end
