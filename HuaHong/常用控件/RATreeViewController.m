//
//  RATreeViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/12/27.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "RATreeViewController.h"
#import <RATreeView.h>
#import "RaTreeViewCell.h"
#import "ChildrenCell.h"
#import "RaTreeModel.h"

@interface RATreeViewController ()<RATreeViewDataSource, RATreeViewDelegate>
@property (nonatomic,strong) RATreeView *treeView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation RATreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    [self.view addSubview:self.treeView];
}

- (RATreeView *)treeView
{
    if (!_treeView) {
        _treeView = [[RATreeView alloc]initWithFrame:self.view.bounds style:RATreeViewStylePlain];
        _treeView.backgroundColor = [UIColor whiteColor];
        _treeView.delegate = self;
        _treeView.dataSource = self;
        
    }
    
    return _treeView;
}

#pragma mark -----------delegate
//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 50;
}
//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
//    RaTreeViewCell *cell = (RaTreeViewCell *)[treeView cellForItem:item];
//    cell.iconView.image = [UIImage imageNamed:@"open"];
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
//    RaTreeViewCell *cell = (RaTreeViewCell *)[treeView cellForItem:item];
//    cell.iconView.image = [UIImage imageNamed:@"close"];
}
//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    NSLog(@"已经展开了");
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    NSLog(@"已经收缩了");
}

//# dataSource方法

//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    
    //当前item
    RaTreeModel *model = item;
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    
    //获取cell
   
    
    
    if (level == 0) {
         RaTreeViewCell *cell = [RaTreeViewCell treeViewCellWith:treeView];
        //赋值
        [cell setCellBasicInfoWith:model.name level:level children:model.children.count];
        return cell;
    }else
    {
       ChildrenCell *cell = [ChildrenCell treeViewCellWith:treeView];
        [cell setCellBasicInfoWith:model.name level:level children:model.children.count];
        return cell;
    }
    
    
    
}
/**
 *  必须实现
 *
 *  @param treeView treeView
 *  @param item    节点对应的item
 *
 *  @return  返回子集合的数量
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    RaTreeModel *model = item;
    if (item == nil) {
        return self.dataArray.count;
    }
    return model.children.count;
    
}
/**
 *必须实现的dataSource方法
 *
 *  @param treeView treeView
 *  @param index    子节点的索引
 *  @param item     子节点索引对应的item
 *
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    RaTreeModel *model = item;
    if (item==nil) {
        return self.dataArray[index];
    }
    return model.children[index];
    
}
//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    //获取当前的层
    NSInteger level = [treeView levelForCellForItem:item];
    //当前点击的model
    RaTreeModel *model = item;
    NSLog(@"点击的是第%ld层,name=%@",(long)level,model.name);
}
//是否允许编辑 默认是YES
//- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
//    return NO;
//}
////编辑要实现的方法
//- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {
//    NSLog(@"编辑了实现的方法");
//}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)setData
{
    
    RaTreeModel *area1 = [RaTreeModel dataObjectWithName:@"羊庄镇" children:nil];
    RaTreeModel *area2 = [RaTreeModel dataObjectWithName:@"木石镇" children:nil];

    RaTreeModel *city1 = [RaTreeModel dataObjectWithName:@"滕州市1" children:@[area1]];
    RaTreeModel *city2 = [RaTreeModel dataObjectWithName:@"滕州市2" children:@[area2]];

    
    
    [self.dataArray addObjectsFromArray:@[area1,area2,city1,city2]];
}

@end
