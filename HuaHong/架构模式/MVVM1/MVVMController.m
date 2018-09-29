//
//  MVVMController.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVMController.h"
#import "MVVMViewModel.h"
#import "MVVMView.h"
#import "MVVMModel.h"
@interface MVVMController ()

@property (nonatomic,strong)MVVMViewModel *viewModel;
@property (nonatomic,strong)MVVMView *mvvmView;
@property (nonatomic,strong)MVVMModel *model;

@end

@implementation MVVMController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.model = [MVVMModel new];
    self.model.content = @"line 0";
    
    self.viewModel = [MVVMViewModel new];

    self.mvvmView = [MVVMView new];
    _mvvmView.frame = self.view.bounds;
    [self.view addSubview:_mvvmView];
    
    [self.viewModel setModel:_model];
    [self.mvvmView setWithViewModel:_viewModel];
}


@end
