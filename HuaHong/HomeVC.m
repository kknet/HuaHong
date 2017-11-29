//
//  HomeVC.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "HomeVC.h"
#import "MapViewController.h"
@interface HomeVC ()
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) NSDictionary *dataSource;
@property (nonatomic,assign) NSInteger selectIndex;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    
    _selectIndex = 0;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"home.plist" ofType:nil];
    _dataSource = [NSDictionary dictionaryWithContentsOfFile:path];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    [_leftTableView setTableFooterView:[UIView new]];
    [_rightTableView setTableFooterView:[UIView new]];

    NSLog(@"_dataSource:%@",[Utils convertToJsonFrom:_dataSource]);
}


-(UITableView *)leftTableView
{
    if(_leftTableView == nil)
    {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, 150, kScreenHeight-49) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
//    _leftTableView.backgroundColor = [UIColor cyanColor];

    return _leftTableView;
}

-(UITableView *)rightTableView
{
    if(_rightTableView == nil)
    {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(_leftTableView.right, 64, kScreenWidth-_leftTableView.right, kScreenHeight-64-49) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.pagingEnabled = YES;
//        _rightTableView.backgroundColor = [UIColor redColor];
    }
    
    return _rightTableView;
}

#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _leftTableView)
    {
        return _dataSource.allKeys.count;
    }else
    {
        NSString *Key = [_dataSource.allKeys objectAtIndex:_selectIndex];
        NSArray *array = [_dataSource objectForKey:Key];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSArray *keyArr = [_dataSource allKeys];
    
    if(tableView == _leftTableView){
        NSString *key = [keyArr objectAtIndex:indexPath.row];
        cell.textLabel.text = key;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;

    }else
    {
        NSArray *valueArr = [_dataSource objectForKey:[keyArr objectAtIndex:_selectIndex]];
        cell.detailTextLabel.text = [valueArr objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _leftTableView)
    {
        _selectIndex = indexPath.row;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_rightTableView reloadData];
    }
    
    if(tableView == _rightTableView)
    {
        switch (indexPath.row) {
            case 0:
            {
                MapViewController *mapVC = [[MapViewController alloc]init];
                mapVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mapVC animated:YES];

            }
                break;
                
            default:
                break;
        }
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.leftTableView) return;
    
    NSIndexPath *indexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
//    _selectIndex = indexpath.row;

    [self.leftTableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    [_rightTableView reloadData];
}


@end
