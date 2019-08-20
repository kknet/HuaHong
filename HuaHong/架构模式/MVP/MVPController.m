//
//  MVPController.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVPController.h"
#import "MVPTableViewCell.h"
#import "MVPModel.h"
#import "Presenter.h"
#import "HHDataSource.h"

static NSString *const reuserId = @"reuserId";

@interface MVPController ()<PresentDelegate>
@property (nonatomic, strong) Presenter *present;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HHDataSource *dataSource;
@end

@implementation MVPController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.present = [Presenter new];

    __weak typeof(self) weakSelf = self;
    self.dataSource = [[HHDataSource alloc] initWithIdentifier:reuserId configureBlock:^(MVPTableViewCell *cell, MVPModel *model, NSIndexPath *indexPath) {
        
        cell.nameLabel.text = model.name;
        cell.numLabel.text  = model.num;
        cell.indexPath      = indexPath;
        cell.delegate       = weakSelf.present;
        
    } selectBlock:^(NSIndexPath *indexPath) {
        NSLog(@"点击了%ld行cell", (long)indexPath.row);
    }];
    
    [self.dataSource addDataArray:self.present.dataArray];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    self.present.delegate          = self;
}



- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[MVPTableViewCell class] forCellReuseIdentifier:reuserId];
    }
    return _tableView;
}

#pragma mark - PresentDelegate
- (void)reloadDataForUI{
    [self.dataSource addDataArray:self.present.dataArray];
    [self.tableView reloadData];
}


@end
