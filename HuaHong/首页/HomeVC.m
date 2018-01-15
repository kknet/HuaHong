//
//  HomeVC.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "HomeVC.h"
#import "HomeFlowLayout.h"
#import "CollectionHeadView.h"
#import "HomeLeftCell.h"


@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSMutableArray *tableTittleDataArray;
@property(nonatomic,strong) NSMutableArray *headTittleDataArray;
@property(nonatomic,strong) NSMutableArray *headImageDataArray;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HomeVC
{
    NSInteger _selectIndex;//记录位置
    BOOL _isScrollDown;//滚动方向
}

static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";

// 导航栏是否消失
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;

    _selectIndex = 0;
    _isScrollDown = YES;
    
    [self.tableTittleDataArray addObjectsFromArray:@[@"控件",@"定位",@"传感器",@"音频",@"视频",@"相册",@"通讯录",@"二维码",@"动画",@"网络",@"手势交互",@"数据持久化",@"绘图",@"日历",@"图文混排",@"JS交互",@"图表"]];
    
    [self.headTittleDataArray addObjectsFromArray:@[@"基础控件",@"地图定位服务",@"传感器",@"音频",@"视频",@"相册",@"通讯录",@"二维码",@"动画",@"网络",@"手势交互",@"数据持久化",@"绘图",@"日历",@"图文混排",@"JS交互",@"图表"]];
    
    [self.headImageDataArray addObjectsFromArray:@[@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_teacher"]];
    
    [self.dataArray addObjectsFromArray: @[
        @[@"瀑布流",@"tableView"],
        @[@"地图"],
        @[@"光学传感器",@"3DTouch",@"指纹识别"],
        @[@"文字转语音",@"录音",@"语音合成"],
        @[@"视频录制1",@"视频录制2",@"视频录制3",@"视频合成"],
        @[@"相册"],
        @[@"系统通讯录",@"自定义通讯录"],
        @[@"二维码扫描",@"二维码生成"],
        @[@"旋转加载",@"扇形加载"],
        @[@"网络"],
        @[@"手势交互"],
        @[@"数据持久化"],
        @[@"绘图"],
        @[@"日历"],
        @[@"图文混排"],
        @[@"JS交互"],
        @[@"图表"]
        ]];
    
    
    
    
    // tableView 的添加
    [self.view addSubview:self.tableView];

    // collectionView 的添加
    [self.view addSubview:self.collectionView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:@selector(testAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)testAction
{
    [self.navigationController pushViewController:[[TestViewController alloc]init] animated:YES];
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

-(NSMutableArray *)headTittleDataArray{
    
    if (!_headTittleDataArray) {
        _headTittleDataArray = [[NSMutableArray alloc]init];
    }
    return _headTittleDataArray;
}

-(NSMutableArray *)headImageDataArray{
    
    if (!_headImageDataArray) {
        _headImageDataArray = [[NSMutableArray alloc]init];
    }
    return _headImageDataArray;
}

-(NSMutableArray *)tableTittleDataArray{
    
    if (!_tableTittleDataArray) {
        _tableTittleDataArray = [[NSMutableArray alloc]init];
    }
    return _tableTittleDataArray;
}


-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kNavBarHeight, 80, kScreenHeight-kNavBarHeight-kTabBarHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor  = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    return _tableView;
}
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableTittleDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    HomeLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[HomeLeftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (_selectIndex == indexPath.row) {
        
        cell.contentView.backgroundColor = [UIColor orangeColor];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    cell.contentLabel.text = self.tableTittleDataArray[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}

// 选中 处理collectionView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    CGRect headerRect = [self frameForHeaderForSection:_selectIndex];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [self.collectionView setContentOffset:topOfHeader animated:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView reloadData];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static float lastOffsetY = 0;
    if (self.collectionView == scrollView) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark - UICollectionViewDataSource
-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        HomeFlowLayout *layout = [HomeFlowLayout new];
        //        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.tableView.right,kNavBarHeight, kScreenWidth-self.tableView.width-0, kScreenHeight-kNavBarHeight-kTabBarHeight) collectionViewLayout: layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.pagingEnabled = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        [_collectionView registerClass:[CollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    }
    
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.headTittleDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataArray[indexPath.section];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (cell.contentView.subviews.count == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:cell.contentView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.layer.borderWidth = 0.5;
        [cell.contentView addSubview:label];
        label.text = array[indexPath.row];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.text = array[indexPath.row];
        }
    }
    
    return cell;
    
    
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //         当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
    //当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index {

    _selectIndex = index;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self.tableView reloadData];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    CollectionHeadView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    header.backgroundColor = [UIColor lightGrayColor];
    header.iconImage.image = [UIImage imageNamed:self.headImageDataArray[indexPath.section]];
    header.headText.text = [NSString stringWithFormat:@"%@",self.headTittleDataArray[indexPath.section]];
    
    
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(0, 40);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        
        return CGSizeMake(0, 8);
    }
    
    return CGSizeZero;
}


//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3.f;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0,0);
}
/*
 格子的宽高设置
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-self.tableView.right-15)/3.0, 40);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.item == 0) {
                WaterFallController *waterfallVC = [[WaterFallController alloc]init];
                [self.navigationController pushViewController:waterfallVC animated:YES];
            }else if (indexPath.item == 1) {
//                TableViewVC *tableVC = [[TableViewVC alloc]init];
               
                id objc = [[NSClassFromString(@"TableViewVC") alloc]init];
                [self.navigationController pushViewController:objc animated:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.item == 0) {
                MapViewController *mapVC = [[MapViewController alloc]init];
                [self.navigationController pushViewController:mapVC animated:YES];
            }
        }
            break;
            
        case 2:
        {
            if (indexPath.item == 0) {
                LightSinceController *lightVC = [[LightSinceController alloc]init];
                [self.navigationController pushViewController:lightVC animated:YES];
            }else if (indexPath.item == 1){
                ThreeDTouchController *touchVC = [[ThreeDTouchController alloc]init];
                [self.navigationController pushViewController:touchVC animated:YES];
            }
        }
            break;
        case 3:
        {
            if (indexPath.item == 0)
            {
                VoiceController *voiceVC = [[VoiceController alloc]init];
                [self.navigationController pushViewController:voiceVC animated:YES];
            }else if (indexPath.item == 1)
            {
                RecorderViewController *voiceVC = [[RecorderViewController alloc]init];
                [self.navigationController pushViewController:voiceVC animated:YES];
            }
        }
            break;
        case 4:
        {
            if (indexPath.item == 0)
            {
                ImagePickController *pickerVC = [[ImagePickController alloc]init];
                [self.navigationController pushViewController:pickerVC animated:YES];
            }else if (indexPath.item == 1)
            {
                MovieFileOutputController *VC = [[MovieFileOutputController alloc]init];
                [self presentViewController:VC animated:YES completion:nil];
            }else if (indexPath.item == 2)
            {
                CustomVideoController *VC = [[CustomVideoController alloc]init];
                [self presentViewController:VC animated:YES completion:nil];
            }else if (indexPath.item == 3)
            {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                AddVideoController *vc = [story instantiateViewControllerWithIdentifier:@"AddVideoController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
            
        case 5:
        {
            if (indexPath.item == 0) {
                TakePhotoController *takePhotoVC = [[TakePhotoController alloc]init];
                [self.navigationController pushViewController:takePhotoVC animated:YES];
            }
        }
            break;
        case 6:
        {
            if (indexPath.item == 0)
            {
                ContactsController *contactVC = [[ContactsController alloc]init];
                [self.navigationController pushViewController:contactVC animated:YES];
            }else if (indexPath.item == 1)
            {
                CustomContactsController *contactVC = [[CustomContactsController alloc]init];
                [self.navigationController pushViewController:contactVC animated:YES];
            }
        }
            break;
        case 7:
        {
            if (indexPath.item == 0) {
                QRCodeController *takePhotoVC = [[QRCodeController alloc]init];
                [self.navigationController pushViewController:takePhotoVC animated:YES];
            }else if (indexPath.item == 1)
            {
                UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                CreatQRCodeController *takePhotoVC = [storyboard instantiateViewControllerWithIdentifier:@"CreatQRCodeController"];
                [self.navigationController pushViewController:takePhotoVC animated:YES];
            }
        }
            break;
        case 8:
        {
            if (indexPath.item == 0) {
                AnimationController *takePhotoVC = [[AnimationController alloc]init];
                [self.navigationController pushViewController:takePhotoVC animated:YES];
            }else if (indexPath.item == 1) {
                LoadingViewController *takePhotoVC = [[LoadingViewController alloc]init];
                [self.navigationController pushViewController:takePhotoVC animated:YES];
            }
        }
            break;
        case 9:
        {
            if (indexPath.item == 0) {
                
                MultiRequestController *VC = [[MultiRequestController alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

@end



