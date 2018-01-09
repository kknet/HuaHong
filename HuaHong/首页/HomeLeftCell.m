//
//  HomeLeftCell.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HomeLeftCell.h"

@implementation HomeLeftCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentLabel];
    }
    
    return self;
}

-(UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        CGRect rect = CGRectMake(0, 0, 80, 40);
        
        NSString *rectStr = NSStringFromCGRect(rect);
//        NSLog(@"rectStr :%@",rectStr);
        CGRect rect1 = CGRectFromString(rectStr);

        _contentLabel = [[UILabel alloc]initWithFrame:rect1];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _contentLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
