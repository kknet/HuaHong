//
//  MVVMTableViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVMTableViewController.h"
#import "MVVM_Model.h"
#import "MVVM_Cell.h"
#import "MVVM_HeaderView.h"
#import "MVVM_ViewModel.h"
@interface MVVMTableViewController ()
@property (nonatomic, strong)MVVM_ViewModel * viewModel;
@end

@implementation MVVMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  self.tableView.tableHeaderView = [[MVVM_HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    self.viewModel = [[MVVM_ViewModel alloc]init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.viewModel tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.viewModel tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.viewModel titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [self.viewModel titleForFooterInSection:section];
}
@end
