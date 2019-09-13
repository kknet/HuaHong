//
//  MVVM_Controller.m
//  HuaHong
//
//  Created by 华宏 on 2018/12/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVM_Controller.h"
//#import <BlocksKit/BlocksKit.h>
//#import <BlocksKit/A2DynamicDelegate.h>
#import "MVVM_Cell.h"
#import "MVVM_ViewModel.h"
#import "MVVM_Model.h"

#define scaledCellValue(value) ( floorf(CGRectGetWidth(collectionView.frame) / 375 * (value)) )

@interface MVVM_Controller ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) MVVM_ViewModel *viewModel;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MVVM_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MVVM";
    //初始化UI
    [self initUI];
    
    //绑定ViewModel
    [self bindViewModel];
}


- (void)initUI
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.collectionView = collectionView;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;


    //注册cell
    [self.collectionView registerClass:[MVVM_Cell class] forCellWithReuseIdentifier:[MVVM_Cell cellReuseIdentifier]];
 
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MVVM_Cell<MVVM_ModelDelegate> *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MVVM_Cell cellReuseIdentifier] forIndexPath:indexPath];
    cell.viewModel = _viewModel;
    if ([cell respondsToSelector:@selector(setModel:)]) {
        [cell setModel:self.dataArray[indexPath.row]];
        
    }
    return (UICollectionViewCell *)cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
   return CGSizeMake(scaledCellValue(100), scaledCellValue(120));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
  return UIEdgeInsetsMake(0, 15, 0, 15);
}

/**
 viewModel绑定
 */
- (void)bindViewModel {
    @weakify(self);
    //将命令执行后的数据交给controller
    
    //第一种写法
//    [self.viewModel.command.executionSignals.switchToLatest subscribeNext:^(NSArray<MVVM_Model *> *array) {
//        @strongify(self);
//        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
//        self.dataArray = array;
//        [self.collectionView reloadData];
//    }];
//
//    //执行command
//    [self.viewModel.command execute:nil];
//    [SVProgressHUD showWithStatus:@"加载中..."];
    
    //第二种写法
    [[self.viewModel.command execute:@{@"key":@"value"}] subscribeNext:^(NSArray<MVVM_Model *> *array) {
        @strongify(self);
//        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        self.dataArray = array;
        [self.collectionView reloadData];
    }];
    
//    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [RACObserve(self.viewModel, isNeedRefresh)subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            [self.collectionView reloadData];
        }
    }];
}

- (MVVM_ViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MVVM_ViewModel alloc] init];
    }
    return _viewModel;
}


//    //collectionView dataSouce
//    A2DynamicDelegate *dataSouce = self.collectionView.bk_dynamicDataSource;
//
//    //item个数
//    [dataSouce implementMethod:@selector(collectionView:numberOfItemsInSection:) withBlock:^NSInteger(UICollectionView *collectionView, NSInteger section) {
//        return self.dataArray.count;
//    }];
//
//    //Cell
//    [dataSouce implementMethod:@selector(collectionView:cellForItemAtIndexPath:) withBlock:^UICollectionViewCell*(UICollectionView *collectionView,NSIndexPath *indexPath) {
//
//        //id<MovieModelProtocol> cell = nil;
//        MVVM_Cell<MVVM_ModelDelegate> *cell = nil;
//
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MVVM_Cell cellReuseIdentifier] forIndexPath:indexPath];
//        cell.viewModel = _viewModel;
//        if ([cell respondsToSelector:@selector(setModel:)]) {
//            [cell setModel:self.dataArray[indexPath.row]];
//
//        }
//        return (UICollectionViewCell *)cell;
//    }];
//
//
//    //delegate
//    A2DynamicDelegate *delegate = self.collectionView.bk_dynamicDelegate;
//
//    //item Size
//    [delegate implementMethod:@selector(collectionView:layout:sizeForItemAtIndexPath:) withBlock:^CGSize(UICollectionView *collectionView,UICollectionViewLayout *layout,NSIndexPath *indexPath) {
//        return CGSizeMake(scaledCellValue(100), scaledCellValue(120));
//    }];
//
//    //内边距
//    [delegate implementMethod:@selector(collectionView:layout:insetForSectionAtIndex:) withBlock:^UIEdgeInsets(UICollectionView *collectionView ,UICollectionViewLayout *layout, NSInteger section) {
//        return UIEdgeInsetsMake(0, 15, 0, 15);
//    }];

@end
