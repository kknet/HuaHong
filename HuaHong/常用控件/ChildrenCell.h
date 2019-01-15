//
//  ChildrenCell.h
//  HuaHong
//
//  Created by 华宏 on 2018/12/27.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RATreeView.h>

@interface ChildrenCell : UITableViewCell
//赋值
- (void)setCellBasicInfoWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children;

+ (instancetype)treeViewCellWith:(RATreeView *)treeView;
@end

