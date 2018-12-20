//
//  MVVMView.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVMView.h"

@implementation MVVMView

- (void)setWithViewModel:(MVVMViewModel *)vm
{
    _viewModel = vm;
    
    /** RAC-KVO */
    [vm rac_observeKeyPath:@"contentStr" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        NSLog(@"newContent:%@",change[NSKeyValueChangeNewKey]);
    }];
    
    
    [vm rac_observeKeyPath:@"model" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        NSLog(@"model:%@",change[NSKeyValueChangeNewKey]);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_viewModel onPrintClick];
}

@end
