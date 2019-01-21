//
//  MVVM_Cell.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVVM_ViewModel.h"

@interface MVVM_Cell : UICollectionViewCell

@property (nonatomic,strong) MVVM_ViewModel *viewModel;
+ (NSString *)cellReuseIdentifier;

@end
