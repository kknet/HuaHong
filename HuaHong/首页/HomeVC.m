//
//  HomeVC.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "HomeVC.h"
#import "FlowLayout.h"
#import "CollectionHeadView.h"
#import "MapViewController.h"
#import "WaterFallController.h"
#import "LightSinceController.h"
#import "ThreeDTouchController.h"

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
    FlowLayout *layout;
    NSInteger _selectIndex;//记录位置
    BOOL _isScrollDown;//滚动方向
}

static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
//    self.edgesForExtendedLayout = UIRectEdgeNone;

    NSLog(@"NavBarHeight:%f,",kNavBarHeight);
    NSLog(@"TabBarHeight:%f,",kTabBarHeight);

    _selectIndex = 0;
    _isScrollDown = YES;
    
    [self.tableTittleDataArray addObjectsFromArray:@[@"Collection",@"定位",@"传感器",@"专家2",@"CIO2",@"教师2",@"专家3",@"CIO3",@"教师3",@"专家4",@"CIO4",@"教师4",@"专家5",@"CIO5",@"教师5",@"专家6",@"教师6"]];
    
    [self.headTittleDataArray addObjectsFromArray:@[@"CollectionView",@"地图定位服务",@"传感器",@"专家领域2",@"CIO领域2",@"教师领域2",@"专家领域3",@"CIO领域3",@"教师领域3",@"专家领域4",@"CIO领域4",@"教师领域4",@"专家领域5",@"CIO领域5",@"教师领域5",@"专家领域6",@"教师领域6"]];
    
    [self.headImageDataArray addObjectsFromArray:@[@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_cio",@"search_teacher",@"search_expert",@"search_teacher"]];
    
    [self.dataArray addObjectsFromArray: @[
        @[@"瀑布流",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能",@"其他"],
        @[@"Apple Map",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合"],
        @[@"光学传感器",@"3DTouch",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化",@"电子商务",@"物联网",@"移动互联网",@"电脑设计",@"数字媒体",@"地理信息系统",@"医学信息学",@"计算机应用",@"其他"],
        @[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"其他"],
        @[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合",@"其他"],
        @[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化",@"电子商务",@"物联网",@"移动互联网",@"电脑设计",@"数字媒体",@"地理信息系统",@"医学信息学",@"计算机应用",@"其他"],
        @[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能",@"数据中心"],
        @[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"机械",@"IT",@"食品",@"餐饮",@"综合",@"其他"],
        @[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据"],
        @[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能"],
        @[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合",@"其他"],
        @[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化",@"电子商务"],
        @[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理"],
        @[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业"],
        @[@"全部",@"软件工程",@"数据库",@"电子工程",@"网络工程",@"通信工程",@"云计算",@"人工智能",@"信息安全",@"信息管理",@"大数据",@"自动化"],
        @[@"全部",@"云计算",@"大数据",@"物联网",@"移动应用",@"区块链",@"网络技术",@"互联网技术",@"产品设计",@"产品运营",@"人工智能",@"信息安全",@"数据治理",@"商务智能",@"智慧城市",@"电子政务",@"智能制造",@"金融科技"],
        @[@"全部",@"金融",@"房地产",@"建筑",@"能源",@"化工",@"政府",@"服装",@"汽车",@"交通",@"医疗",@"医药",@"教育",@"农业",@"物流",@"商贸",@"酒店",@"旅游",@"冶金",@"电器",@"机械",@"IT",@"食品",@"餐饮",@"综合"]
        ]];
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[CollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    
    // tableView 的添加
    [self.view addSubview:self.tableView];
    
    // collectionView 的添加
    [self.view addSubview:self.collectionView];
    
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

// 导航栏是否消失
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.f;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1, 0, 1,0);
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
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        case 5:
        {
            
        }
            break;
            
        default:
            break;
    }
}
-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        layout = [FlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.tableView.right+5,0, kScreenWidth-self.tableView.width-10, kScreenHeight-kNavBarHeight-kTabBarHeight) collectionViewLayout: layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.pagingEnabled = NO;
    }
    
    return _collectionView;
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
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, 100, kScreenHeight-kNavBarHeight-kTabBarHeight)];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor  = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableTittleDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_selectIndex == indexPath.row) {
        
        cell.contentView.backgroundColor = [UIColor orangeColor];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = self.tableTittleDataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
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

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static float lastOffsetY = 0;
    if (self.collectionView == scrollView) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
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

- (CGRect)frameForHeaderForSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}




@end



