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

//后台拉取回调
-(void)completationHandler:(void (^)(UIBackgroundFetchResult))completationHandler
{
    NSLog(@"UIBackgroundFetchResultNewData");
    completationHandler(UIBackgroundFetchResultNewData);
}

// 导航栏是否消失
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    
    
/*
    //导航栏黑色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //关闭导航栏半透明效果
    self.navigationController.navigationBar.translucent = NO;
    
    //状态栏白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
 */
    
//    self.navigationController.hidesBarsOnSwipe = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;

    _selectIndex = 0;
    _isScrollDown = YES;
    
    [self.tableTittleDataArray addObjectsFromArray:@[@"控件",@"定位",@"传感器",@"音频",@"视频",@"相册",@"通讯录",@"二维码",@"动画",@"网络",@"手势交互",@"数据持久化",@"绘图",@"日历",@"图文混排",@"JS交互",@"图表",@"多线程",@"编程思想",@"蓝牙",@"智能识别",@"设计模式",@"其他"]];
    
    [self.dataArray addObjectsFromArray: @[
        @[@"瀑布流",@"tableView",@"WKWebView",@"block",@"TextView",@"Button",@"MenuControll",@"PageControl",@"UIWebView"],
        @[@"苹果地图" ,@"大头针",@"系统地图导航",@"百度地图"],
        @[@"光学传感器",@"3DTouch",@"指纹识别",@"距离传感器",@"重力传感器",@"碰撞",@"甩行为",@"附着行为",@"推行为",@"加速计陀螺仪磁力针",@"计步器"],
        @[@"文字转语音",@"录音",@"语音合成"],
        @[@"视频录制1",@"视频录制2",@"视频录制3",@"视频合成"],
        @[@"相册"],
        @[@"系统通讯录",@"自定义通讯录"],
        @[@"二维码扫描",@"二维码生成"],
        @[@"基本动画",@"扇形加载",@"转场动画"],
        @[@"多网络请求",@"session请求",@"下载",@"上传",@"Https证书",@"删除数据",@"XML解析",@"JSON/Plist",@"AFN"],
        @[@"触摸手势交互"],
        @[@"数据存储",@"云端存储",@"CoreData",@"SQLite"],
        @[@"绘图",@"时钟",@"画板"],
        @[@"日历"],
        @[@"图文混排"],
        @[@"JS交互"],
        @[@"图表"],
        @[@"多线程"],
        @[@"RAC",@"函数式编程",@"链式编程",@"runtime",@"runloop"],
        @[@"蓝牙",@"蓝牙外设"],
        @[@"人脸识别",@"手势解锁",@"卡片识别"],
        @[@"策略模式",@"桥接模式"],
        @[@"计时器",@"密码安全",@"正则表达式",@"分段选择"]
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
//    HHPhotoBrowserController *vc = [HHPhotoBrowserController new];
//    [self presentViewController:vc animated:YES completion:nil];
    
    TestViewController *vc = [kStory instantiateViewControllerWithIdentifier:@"TestViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]];
    
    
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
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);

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

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//
//    return UIEdgeInsetsMake(0,0,0,0);
//}

/*
 格子的宽高设置
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemSpace = 3.0;//item列间距
    NSInteger line = 3;//行
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)collectionViewLayout;
    

    
    return CGSizeMake((collectionView.size.width -layout.sectionInset.left - layout.sectionInset.right - (line-1)*itemSpace)/line, 40);
}


/**
 cmd + option + /

 @param collectionView <#collectionView description#>
 @param indexPath <#indexPath description#>
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
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
                vc = [WKWebViewVC new];
                
            }else if (indexPath.item == 3)
            {
                vc = [BlockVC new];
                
            }else if (indexPath.item == 4)
            {
                vc = [TextViewVC new];
                vc.title = @"图文混排&硬件信息";

            }else if (indexPath.item == 5)
            {
                vc = [ButtonVC new];
            }else if (indexPath.item == 6)
            {
                vc = [MenuControllerVC new];
            }else if (indexPath.item == 7)
            {
                vc = [PageControlVC new];
            }else if (indexPath.item == 8)
            {
                vc = [WebViewVC new];
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
                vc = [[LightSinceController alloc]init];
                vc.title = @"光学传感器";

            }else if (indexPath.item == 1){
                vc = [[ThreeDTouchController alloc]init];
                vc.title = @"3DTouch";

                
            }else if (indexPath.item == 2){
                vc = [SecurityController new];
                vc.title = @"指纹识别";
            }else if (indexPath.item == 3){
                vc = [[NSClassFromString(@"DistanceController") alloc]init];
                vc.title = @"距离传感器";

            }
            else if (indexPath.item == 4){
                vc = [[GravityViewController alloc]init];
                vc.title = @"重力传感器";

            }
            else if (indexPath.item == 5){
                vc = [[CollisionViewController alloc]init];
                vc.title = @"碰撞";

            }else if (indexPath.item == 6){
                vc = [[SnapViewController alloc]init];
                vc.title = @"甩行为";
            }
            else if (indexPath.item == 7){
                vc = [[AttachmentBehaviorController alloc]init];
                vc.title = @"附着行为";

            }
            else if (indexPath.item == 8){
                vc = [[PushBehaviorController alloc]init];
                vc.title = @"推行为";

            }
            else if (indexPath.item == 9){
                //CoreMotion
                vc = [[CoreMotionController alloc]init];
                vc.title = @"加速计、陀螺仪、磁力计";

            }
            else if (indexPath.item == 10){
                vc = [[PedometerViewController alloc]init];
                vc.title = @"计步器";
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
                
                vc = (AnimationController *)[[AnimationController alloc]init];
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
                vc.title = @"多网络请求";

            }else if (indexPath.item == 1) {
                
                vc = [[SessionRequestController alloc]init];
                vc.title = @"session请求";

            }else if (indexPath.item == 2) {
                
               vc = [kStory instantiateViewControllerWithIdentifier:@"DownLoadViewController"];
                vc.title = @"下载";
            }else if (indexPath.item == 3) {
                
                vc = [[UpLoadViewController alloc]init];
                vc.title = @"上传";
                
            }else if (indexPath.item == 4) {
                
                vc = [[HttpsController alloc]init];
                vc.title = @"Https证书";
                
                
            }else if (indexPath.item == 5) {
                
                vc = [[DeleteFileController alloc]init];
                vc.title = @"删除服务器文件";
                
            }else if (indexPath.item == 6) {
                
                vc = [[XMLController alloc]init];
                vc.title = @"XML解析";
                
            }else if (indexPath.item == 7) {
                
                vc = [[JSONPlistController alloc]init];
                vc.title = @"JSON/Plist";
                
            }else if (indexPath.item == 8) {
                
                vc = [[AFController alloc]init];
                vc.title = @"AFN";
                
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
                vc = [kStory instantiateViewControllerWithIdentifier:@"LeanCloudViewController"];
                vc.title = @"LeanCloud";
                
            }else if (indexPath.item == 2)
            {
                vc = [kStory instantiateViewControllerWithIdentifier:@"CoreDataController"];
                vc.title = @"CoreData";
            }
            else if (indexPath.item == 3)
            {
                vc = [kStory instantiateViewControllerWithIdentifier:@"HHFMDBController"];
                vc.title = @"SQLite";
            }

        }
            break;

        case 12:
        {
            if (indexPath.item == 0) {
                
                vc = [kStory instantiateViewControllerWithIdentifier:@"DrawView"];
                vc.navigationItem.title = @"绘图";
                
            }else if (indexPath.item == 1)
            {
                vc = [ClockViewController new];
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
        
//            vc = [WebViewController new];
//            vc.navigationItem.title = @"JS互调";
            
        }
            break;
        case 16:
        {
            
        }
            break;
        case 17:
        {
            if (indexPath.item == 0) {
                
                vc = [ThreadViewController new];
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
                vc = [kStory instantiateViewControllerWithIdentifier:@"RACViewController"];
                vc.navigationItem.title = @"RAC";

            }else if (indexPath.item == 1)
            {
                vc = [FunctionViewController new];
                vc.title = @"函数式编程";
                
            }else if (indexPath.item == 2)
            {
                vc = [ChainViewController new];
                vc.title = @"链式编程";

            }else if (indexPath.item == 3)
            {
                vc = [runtimeViewController new];
                vc.title = @"runtime";
                
            }else if (indexPath.item == 4)
            {
                vc = [runloopViewController new];
                vc.title = @"runloop";
            }
        }
            break;
            case 19:
        {
            if (indexPath.item == 0) {
                
                vc = [kStory instantiateViewControllerWithIdentifier:@"BlueToothController"];
                vc.navigationItem.title = @"蓝牙";

            }else if (indexPath.item == 1)
            {
                vc = [kStory instantiateViewControllerWithIdentifier:@"CBPeripheralViewController"];
                vc.navigationItem.title = @"蓝牙外设";
            }
            
        }
            break;
            case 20:
        {
            if (indexPath.item == 0) {
                
                vc = [FaceViewController new];
                vc.navigationItem.title = @"人脸识别";
            }else if (indexPath.item == 1)
            {
                vc = [HHLockController new];
                vc.navigationItem.title = @"手势解锁";
            }else if (indexPath.item == 2)
            {
                vc = [HHCardController new];
                vc.navigationItem.title = @"卡片识别";
            }
        }
            break;
        case 21:
        {
            if (indexPath.item == 0) {
                
                vc = [kStory instantiateViewControllerWithIdentifier:@"StrategyController"];
                vc.navigationItem.title = @"策略模式";
            }else if (indexPath.item == 1)
            {
                vc = [BridgeController new];
                vc.navigationItem.title = @"桥接模式";
            }
        }
            break;
            case 22:
        {
            if (indexPath.item == 0) {
                
                vc = [TimerController new];
                vc.navigationItem.title = @"计时器";

            }else if (indexPath.item == 1)
            {
                vc = [SecurityController new];
                vc.navigationItem.title = @"密码安全";

            }else if (indexPath.item == 2)
            {
                vc = [RegularExpressionController new];
                vc.navigationItem.title = @"正则表达式";
            }else if (indexPath.item == 3)
            {
                vc = [kStory instantiateViewControllerWithIdentifier:@"HHSegmentController"];
                vc.navigationItem.title = @"分段选择";
            }
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];

}


@end



