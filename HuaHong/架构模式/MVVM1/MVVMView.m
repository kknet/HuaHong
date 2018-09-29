//
//  MVVMView.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVMView.h"
@implementation MVVMView
{
    FBKVOController *_fbKVOContrl;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapAction)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)setWithViewModel:(MVVMViewModel *)vm
{
    _viewModel = vm;
    
    /** 系统KVO */
//   [vm addObserver:self forKeyPath:@"contentStr" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    /** FBKVO -1 */
//    _fbKVOContrl = [FBKVOController controllerWithObserver:self];
//   [_fbKVOContrl observe:vm keyPath:@"contentStr" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
//
//        NSString *newContent = change[NSKeyValueChangeNewKey];
//
//        NSLog(@"newContent:%@",newContent);
//    }];
    
//    /** FBKVO-2 */
//    [self.KVOController observe:vm keyPaths:@[@"contentStr"] options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
//        
//        NSLog(@"newContent:%@",change[NSKeyValueChangeNewKey]);
//
//    }];
    
    /** RAC-KVO */
    [vm rac_observeKeyPath:@"contentStr" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        NSLog(@"newContent:%@",change[NSKeyValueChangeNewKey]);
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSString *newContent = change[NSKeyValueChangeNewKey];
    
    NSLog(@"newContent:%@",newContent);
}

- (void)viewTapAction
{
    [_viewModel onPrintClick];
}

- (void)dealloc
{
    [_viewModel removeObserver:self forKeyPath:@"contentStr"];
}
@end
