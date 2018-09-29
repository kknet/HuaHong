//
//  MVVMViewModel.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVVMModel.h"

@interface MVVMViewModel : NSObject

@property (nonatomic,copy) NSString *contentStr;
@property (nonatomic,strong) MVVMModel *model;

- (void)onPrintClick;

@end
