//
//  MVPTableViewCell.h
//  HuaHong
//
//  Created by qk-huahong on 2019/8/19.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVPTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, assign) int num;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<PresentDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
