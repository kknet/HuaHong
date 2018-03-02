//
//  QKCRIndicateHeadView.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/27.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "QKCRIndicateHeadView.h"

@interface QKCRIndicateHeadView()
@property (nonatomic,strong) UILabel *timeLabel;
@end
@implementation QKCRIndicateHeadView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
      
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.timeLabel];

    }
    
    return self;
}

-(UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.backgroundColor = [UIColor lightTextColor];
    }
    
    return _timeLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.timeLabel.center = self.contentView.center;

}

-(void)setTime:(NSString *)text
{
    self.timeLabel.text = text;
    [self.timeLabel sizeToFit];
}
@end
