//
//  AdapterViewController.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "AdapterViewController.h"
#import "Model.h"
#import "ContentView.h"
#import "BaseAdapter.h"
#import "ContentModelAdeapter.h"
#import "ItemModelAdeapter.h"
#import "TestModel.h"
#import "ModelAdapter.h"

@implementation AdapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*========================类适配器===========================*/
    Model *contenModel = [[Model alloc]init];
    contenModel.conntentStr  =  @"时间：10：32:12";
    contenModel.imageName    =  @"shijian";
    
    BaseAdapter *modelAdapter = [[ContentModelAdeapter alloc]initWithData:contenModel];
    
    ContentView *contentView = [[ContentView alloc]initWithFrame:CGRectMake(100, 100, 200, 20)];
    [contentView loadData:modelAdapter];
    [self.view addSubview:contentView];
    
    
    TestModel *itemModel  = [[TestModel alloc]init];
    itemModel.conntentStr =  @"心率：100次";
    itemModel.image       =  [UIImage imageNamed:@"mapHeaderIcon"];
    
    BaseAdapter *modelAdapter1 = [[ItemModelAdeapter alloc]initWithData:itemModel];
    
    ContentView *contentView1 = [[ContentView alloc]initWithFrame:CGRectMake(100, 200, 200, 20)];
    [contentView1 loadData:modelAdapter1];
    [self.view addSubview:contentView1];
    
    /*========================对象适配器===========================*/
    
    TestModel *itemModel1  = [[TestModel alloc]init];
    itemModel1.conntentStr =  @"心率：100次";
    itemModel1.image       =  [UIImage imageNamed:@"mapHeaderIcon"];
    
    BaseAdapter *modelAdapter2 = [[ModelAdapter alloc]initWithData:itemModel];
    
    ContentView *contentView2 = [[ContentView alloc]initWithFrame:CGRectMake(100, 300, 200, 20)];
    [contentView2 loadData:modelAdapter2];
    [self.view addSubview:contentView2];
    
    
    
    Model *contenModel2 = [[Model alloc]init];
    contenModel2.conntentStr  =  @"时间：10：32:12";
    contenModel2.imageName    =  @"shijian";
    
    BaseAdapter *modelAdapter3 = [[ModelAdapter alloc]initWithData:contenModel];
    
    ContentView *contentView3 = [[ContentView alloc]initWithFrame:CGRectMake(100, 400, 200, 20)];
    [contentView3 loadData:modelAdapter3];
    [self.view addSubview:contentView3];
}

@end
