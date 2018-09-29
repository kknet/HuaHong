//
//  MVVM_Cell.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVM_Cell.h"
#import "MVVM_Model.h"

@interface MVVM_Cell()
@property (nonatomic,weak) UIImageView *imgView;
@property (nonatomic,weak) UILabel *subLabel;
@end

@implementation MVVM_Cell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"MVVMCell";
    MVVM_Cell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[MVVM_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

//重写init方法构建cell内容
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //图片
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_model.image]];
        imageView.frame = CGRectMake(5, 5, 80, 60);
        [self.contentView addSubview:imageView];
        self.imgView = imageView;
        //标题
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 15, 200, 20)];
        lable.font = [UIFont systemFontOfSize:20.0f];
        [self.contentView addSubview:lable];
        self.label = lable;
        //副标题
        UILabel * subLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 40, 200, 13)];
        subLable.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:subLable];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return  self;
    
}

//重写set方法,传递模型
- (void)setModel:(MVVM_Model *)model
{
    _model = model;
    self.imageView.image = [UIImage imageNamed:model.image];
    self.label.text = model.title;
    self.subLabel.text = model.subTitle;
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
