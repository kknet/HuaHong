//
//  MVVM_Cell.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MVVM_Model;

@interface MVVM_Cell : UITableViewCell

@property (nonatomic,weak) UILabel *label;
@property (nonatomic,strong) MVVM_Model *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
