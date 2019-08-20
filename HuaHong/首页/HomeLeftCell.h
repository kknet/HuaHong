//
//  HomeLeftCell.h
//  HuaHong
//
//  Created by 华宏 on 2018/1/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block)(void);

@interface HomeLeftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, copy) Block block;
@end
