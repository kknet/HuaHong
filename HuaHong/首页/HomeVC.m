//
//  HomeVC.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "HomeVC.h"
#import "CollectionHeadView.h"
#import "HomeLeftCell.h"


@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSMutableArray *tableTittleDataArray;
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
//    self.navigationController.hidesBarsOnSwipe = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;

    _selectIndex = 0;
    _isScrollDown = YES;
    
    [self.tableTittleDataArray addObjectsFromArray:@[@"控件",@"定位",@"传感器",@"音频",@"视频",@"相册",@"通讯录",@"二维码",@"动画",@"网络",@"手势交互",@"数据持久化",@"绘图",@"日历",@"图文混排",@"JS交互",@"图表",@"多线程",@"编程思想",@"蓝牙",@"智能识别",@"其他"]];
    
    [self.dataArray addObjectsFromArray: @[
        @[@"瀑布流",@"tableView",@"chat",@"block",@"TextView",@"控件"],
        @[@"苹果地图" ,@"大头针",@"系统地图导航",@"百度地图"],
        @[@"光学传感器",@"3DTouch",@"指纹识别",@"距离传感器"],
        @[@"文字转语音",@"录音",@"语音合成"],
        @[@"视频录制1",@"视频录制2",@"视频录制3",@"视频合成"],
        @[@"相册"],
        @[@"系统通讯录",@"自定义通讯录"],
        @[@"二维码扫描",@"二维码生成"],
        @[@"基本动画",@"扇形加载",@"转场动画"],
        @[@"网络1",@"网络2",@"下载"],
        @[@"触摸手势交互"],
        @[@"数据存储",@"云端存储",@"CoreData"],
        @[@"绘图",@"时钟",@"画板"],
        @[@"日历"],
        @[@"图文混排"],
        @[@"JS交互"],
        @[@"图表"],
        @[@"多线程"],
        @[@"响应式编程RAC",@"函数式编程",@"链式编程",@"runtime",@"runloop"],
        @[@"蓝牙",@"蓝牙外设"],
        @[@"人脸识别"],
        @[@"计时器",@"密码安全",@""]
        ]];
    
    
    
    
    // tableView 的添加
    [self.view addSubview:self.tableView];

    // collectionView 的添加
    [self.view addSubview:self.collectionView];
    
    NSString *title = NSLocalizedString(@"title", @"注释");
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(testAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    
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

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

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
    
    cell.contentView.backgroundColor = (_selectIndex == indexPath.row)?  [UIColor orangeColor] : [UIColor whiteColor];
    
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
    
    //设置collectionView滚动
    CGRect headerRect = [self frameForHeaderForSection:_selectIndex];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [self.collectionView setContentOffset:topOfHeader animated:YES];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView reloadData];
    
    
}

- (CGRect)frameForHeaderForSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static float lastOffsetY = 0;
    if ([self.collectionView isEqual: scrollView]) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.tableTittleDataArray.count;
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
    
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index {
    
    _selectIndex = index;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self.tableView reloadData];
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    CollectionHeadView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    header.backgroundColor = [UIColor lightGrayColor];
    header.iconImage.image = [UIImage imageNamed:@"search_expert"];
    header.headText.text = [NSString stringWithFormat:@"%@",self.tableTittleDataArray[indexPath.section]];
    
    
    return header;
}

//Header 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 40);
}

//Footer 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}


//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.0;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0,0,0,0);
}

/*
 格子的宽高设置
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemSpace = 3.0;//item列间距
    NSInteger line = 3;//行
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)collectionViewLayout;
    
    NSLog(@"layout.sectionInset.left:%f",layout.sectionInset.left);
    NSLog(@"contentInset.left:%f",collectionView.contentInset.left);

    
    return CGSizeMake((kScreenWidth-self.tableView.right -layout.sectionInset.left - layout.sectionInset.right - (line-1)*itemSpace)/line, 40);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id vc = nil;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.item == 0)
            {
                vc = [[WaterFallController alloc]init];
                
            }else if (indexPath.item == 1)
            {
                vc = [[NSClassFromString(@"TableViewVC") alloc]init];
                
            }else if (indexPath.item == 2)
            {
                //chat
                vc = [QKCRChatControlViewController new];
                
            }else if (indexPath.item == 3)
            {
                //block
                vc = [BlockViewController new];
                
            }else if (indexPath.item == 4)
            {
                TextViewController *vc = [TextViewController new];
                vc.title = @"图文混排&硬件信息";

            }else if (indexPath.item == 5)
            {
                vc = [ViewController new];
            }
        }
            break;
        case 1:
        {
            if (indexPath.item == 0) {
                //系统自带地图
                vc = [[MapViewController alloc]init];
                
            }else if (indexPath.item == 1)
            {
                //大头针
                vc = [[AnnotationController alloc]init];

            }else if (indexPath.item == 2)
            {
                //系统地图导航/画线
                vc = [kStory instantiateViewControllerWithIdentifier:@"SystemNavigationController"];

            }else if (indexPath.item == 3)
            {
                //百度地图
                vc = [[BaiDuMapController alloc]init];
            }
        }
            break;
            
        case 2:
        {
            if (indexPath.item == 0) {
                //光学传感器
                vc = [[LightSinceController alloc]init];
                
            }else if (indexPath.item == 1){
                //3DTouch
                vc = [[ThreeDTouchController alloc]init];
                
            }else if (indexPath.item == 2){
                
            }else if (indexPath.item == 3){
                //距离传感器
                vc = [[NSClassFromString(@"DistanceController") alloc]init];
                
            }
        }
            break;
        case 3:
        {
            if (indexPath.item == 0)
            {
                vc = [[VoiceController alloc]init];
                
            }else if (indexPath.item == 1)
            {
                vc = [[RecorderViewController alloc]init];
            }
        }
            break;
        case 4:
        {
            if (indexPath.item == 0)
            {
                vc = [[ImagePickController alloc]init];

            }else if (indexPath.item == 1)
            {
                vc = [[MovieFileOutputController alloc]init];

            }else if (indexPath.item == 2)
            {
                CustomVideoController *VC = [[CustomVideoController alloc]init];
                [self presentViewController:VC animated:YES completion:nil];
            }else if (indexPath.item == 3)
            {
                vc = [kStory instantiateViewControllerWithIdentifier:@"AddVideoController"];
            }
        }
            break;
        case 5:
        {
            if (indexPath.item == 0)
            {
                vc = [[TakePhotoController alloc]init];
            }
        }
            break;
        case 6:
        {
            if (indexPath.item == 0)
            {
                vc = [[ContactsController alloc]init];

            }else if (indexPath.item == 1)
            {
                vc = [[CustomContactsController alloc]init];
            }
        }
            break;
        case 7:
        {
            if (indexPath.item == 0) {
                
                vc = [[QRCodeController alloc]init];
                
            }else if (indexPath.item == 1)
            {
                vc = [kStory instantiateViewControllerWithIdentifier:@"CreatQRCodeController"];
            }
        }
            break;
        case 8:
        {
            if (indexPath.item == 0) {
                
                AnimationController *vc = (AnimationController *)[[AnimationController alloc]init];
                vc.title = @"基本动画";
                
            }else if (indexPath.item == 1) {
                
                vc = [[LoadingViewController alloc]init];
                
            }else if (indexPath.item == 2){
                
                vc = [kStory instantiateViewControllerWithIdentifier:@"TransitionController"];
            }
        }
            break;
        case 9:
        {
            if (indexPath.item == 0) {
                
                vc = [[MultiRequestController alloc]init];

            }else if (indexPath.item == 1) {
                
                vc = [[RequestController alloc]init];

            }else if (indexPath.item == 2) {
                
               DownLoadViewController *vc = [kStory instantiateViewControllerWithIdentifier:@"DownLoadViewController"];
                vc.title = @"下载";
            }
        }
            break;
        case 10://手势交互
        {
            if (indexPath.item == 0) {
              //触摸
                vc = [kStory instantiateViewControllerWithIdentifier:@"TouchController"];
            }
        }
            break;
        case 11://数据持久化
        {
            if (indexPath.item == 0) {
                
                vc = [kStory instantiateViewControllerWithIdentifier:@"DataStorageController"];
                
            }else if (indexPath.item == 1)
            {
                LeanCloudViewController *vc = [LeanCloudViewController new];
                vc.title = @"LeanCloud";
                
            }else if (indexPath.item == 2)
            {
                CoreDataController *vc = [CoreDataController new];
                vc.title = @"CoreData";
            }
        }
            break;
        case 12:
        {
            if (indexPath.item == 0) {
                
                UIViewController *vc = [kStory instantiateViewControllerWithIdentifier:@"DrawView"];
                vc.navigationItem.title = @"绘图";
                
            }else if (indexPath.item == 1)
            {
                ClockViewController *vc = [ClockViewController new];
                vc.navigationItem.title = @"时钟";

            }else if (indexPath.item == 2)
            {
                vc = [kStory instantiateViewControllerWithIdentifier:@"DrawingBoardController"];
            }
        }
            break;
            case 13:
        {
            
        }
            break;
        case 14:
        {
            
        }
            break;
        case 15:
        {
        
            WebViewController *vc = [WebViewController new];
            vc.navigationItem.title = @"JS互调";
            
        }
            break;
        case 16:
        {
            
        }
            break;
        case 17:
        {
            if (indexPath.item == 0) {
                
                ThreadViewController *vc = [ThreadViewController new];
                vc.navigationItem.title = @"多线程";

            }else if (indexPath.item == 1)
            {
                
            }
        }
            break;
        case 18:
        {
            if (indexPath.item == 0)
            {
                RACViewController *vc = [kStory instantiateViewControllerWithIdentifier:@"RACViewController"];
                vc.navigationItem.title = @"RAC";

            }else if (indexPath.item == 1)
            {
                FunctionViewController *vc = [FunctionViewController new];
                vc.title = @"函数式编程";
                
            }else if (indexPath.item == 2)
            {
                ChainViewController *vc = [ChainViewController new];
                vc.title = @"链式编程";

            }else if (indexPath.item == 3)
            {
                runtimeViewController *vc = [runtimeViewController new];
                vc.title = @"runtime";
                
            }else if (indexPath.item == 4)
            {
                runloopViewController *vc = [runloopViewController new];
                vc.title = @"runloop";
            }
        }
            break;
            case 19:
        {
            if (indexPath.item == 0) {
                
                BlueToothController *vc = [kStory instantiateViewControllerWithIdentifier:@"BlueToothController"];
                vc.navigationItem.title = @"蓝牙";

            }else if (indexPath.item == 1)
            {
                CBPeripheralViewController *vc = [kStory instantiateViewControllerWithIdentifier:@"CBPeripheralViewController"];
                vc.navigationItem.title = @"蓝牙外设";
            }
            
        }
            break;
            case 20:
        {
            if (indexPath.item == 0) {
                
                FaceViewController *vc = [FaceViewController new];
                vc.navigationItem.title = @"人脸识别";
            }
        }
            break;
            case 21:
        {
            if (indexPath.item == 0) {
                
                TimerController *vc = [TimerController new];
                vc.navigationItem.title = @"计时器";

            }else if (indexPath.item == 1)
            {
                SecurityController *vc = [SecurityController new];
                vc.navigationItem.title = @"密码安全";

            }else if (indexPath.item == 2)
            {
                RACViewController *vc = [kStory instantiateViewControllerWithIdentifier:@"RACViewController"];
                vc.navigationItem.title = @"RAC";
            }
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)completationHandler:(void (^)(UIBackgroundFetchResult))completationHandler
{
    NSLog(@"UIBackgroundFetchResultNewData");
    completationHandler(UIBackgroundFetchResultNewData);
}
@end



