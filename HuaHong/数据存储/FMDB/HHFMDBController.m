//
//  HHFMDBController.m
//  HuaHong
//
//  Created by 华宏 on 2018/5/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHFMDBController.h"
#import "HHFMDBManager.h"
#import "DataModel.h"
@interface HHFMDBController ()
@property (nonatomic,strong) HHFMDBManager *manager;
@end

@implementation HHFMDBController

-(HHFMDBManager *)manager
{
    if (!_manager) {
        _manager = [[HHFMDBManager alloc]init];
    }
    
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)addAction:(id)sender {
    
    DataModel *model = [[DataModel alloc]init];
    model.name = @"zhangsan";
    model.age = 33;
    model.userID = @"1008";
    
    [self.manager insertData:@[model]];
    
    
}

- (IBAction)deleteAction:(id)sender {
    
    [self.manager deleteItem:@"1008"];
}

- (IBAction)updateAction:(id)sender {
    
    DataModel *model = [[DataModel alloc]init];
    model.name = @"lisi";
    model.age = 44;
    model.userID = @"1008";
    
    [self.manager updateItem:model userID:model.userID complte:^(BOOL success) {
        
        if (success) {
            NSLog(@"更新成功");
        }
    }];
}

- (IBAction)queryAction:(id)sender {
    
   NSArray *array = [self.manager queryData];
    
    for (DataModel *model in array) {
        NSLog(@"name:%@,age:%zd,userId:%@",model.name,model.age,model.userID);
    }
}

@end
