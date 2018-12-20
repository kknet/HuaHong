//
//  MVVMViewModel.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVMViewModel.h"

@implementation MVVMViewModel

- (void)onPrintClick
{
    self.model = [MVVMModel new];
    self.model.content = [NSString stringWithFormat:@"%d",arc4random()%100];
    
    self.contentStr = self.model.content;
}

- (void)setModel:(MVVMModel *)model
{
    _model = model;
    
    _contentStr = model.content;
}
@end
