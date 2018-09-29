//
//  MVPController.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVPController.h"
#import "MVPView.h"
#import "MVPModel.h"
#import "Presenter.h"
@interface MVPController ()
@property (nonatomic,strong) Presenter *present;
@property (nonatomic,strong) MVPView *mvpView;
@property (nonatomic,strong) MVPModel *model;

@end

@implementation MVPController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.present = [Presenter new];

    self.mvpView = [[MVPView alloc]init];
    self.mvpView.frame = self.view.bounds;
    [self.view addSubview:_mvpView];
    self.mvpView.delegate = self.present;
    
    self.model = [[MVPModel alloc]init];
    self.model.content = @"line 0";
    
    self.present.model = _model;
    self.present.mvpView = _mvpView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.present printTask];
    });
    
    
}


@end
