//
//  MVVMView.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVVMViewModel.h"

@interface MVVMView : UIView

@property (nonatomic,strong) MVVMViewModel *viewModel;
- (void)setWithViewModel:(MVVMViewModel *)vm;

@end
