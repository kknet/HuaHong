//
//  QKCRIndicateCell.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/26.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "QKCRIndicateCell.h"

@interface QKCRIndicateCell()
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@end
@implementation QKCRIndicateCell
- (IBAction)playAction:(id)sender
{
}

-(void)setProgress:(CGFloat)progress
{
    
    _progressView.progress = progress;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    

//    self.playBtn.layer.borderColor = [UIColor greenColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
