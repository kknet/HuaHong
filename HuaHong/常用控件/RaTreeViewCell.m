//
//  RaTreeViewCell.m
//  HuaHong
//
//  Created by 华宏 on 2018/12/27.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "RaTreeViewCell.h"

@implementation RaTreeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)treeViewCellWith:(RATreeView *)treeView
{
    RaTreeViewCell *cell = [treeView dequeueReusableCellWithIdentifier:@"RaTreeViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RaTreeViewCell" owner:nil options:nil] firstObject];
    }
    
    
    
    return cell;
}

- (void)setCellBasicInfoWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children{
    //有自孩子时显示图标
    if (children==0)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
    }else
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
//    self.titleLable.text = title;
//    self.iconView.image = [UIImage imageNamed:@"close"];
//    //每一层的布局
//    CGFloat left = 10+level*30;
//    //头像的位置
//    CGRect  iconViewFrame = self.iconView.frame;
//    iconViewFrame.origin.x = left;
//    self.iconView.frame = iconViewFrame;
//    //title的位置
//    CGRect titleFrame = self.titleLable.frame;
//    titleFrame.origin.x = 40+left;
//    self.titleLable.frame = titleFrame;
    
    self.textLabel.text = title;
}


@end
