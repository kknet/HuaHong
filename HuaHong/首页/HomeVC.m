//
//  HomeVC.m
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "HomeVC.h"
#import "CollectionHeadView.h"
#import "HomeLeftCell.h"
#import "CollectionCell.h"
#import "HomeData.h"
#import "RouteManager.h"

@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSMutableArray *tableViewArray;
@property (strong, nonatomic) NSMutableArray *collectionViewArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HomeVC
{
    NSInteger _selectIndex;//记录位置
    BOOL _isScrollDown;//滚动方向
}

static NSString *cellID = @"CollectionCell";
static NSString *headerID = @"headerID";

- (void)viewDidLoad {
    [super viewDidLoad];    
    
 
    self.title = @"首页";

    _selectIndex = 0;
    _isScrollDown = YES;
    
    _tableView.tableFooterView = [UIView new];
    _tableViewArray = [NSMutableArray array];
    _collectionViewArray = [NSMutableArray array];
    
    [MBProgressHUD showLoading:@"Loading..." toView:self.view];
    __weak typeof(self) weakSelf = self;
    [self requestData:^(NSArray *tableArray, NSArray *collectionArray,NSError *error) {
      
        [MBProgressHUD hideHUDForView:self.view];
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"请求数据错误"];
            
            _collectionView.emptyDataSetSource = self;
            _collectionView.emptyDataSetDelegate = self;
            
            return ;
        }
        
        
        [weakSelf.tableViewArray addObjectsFromArray:tableArray];
        [weakSelf.collectionViewArray addObjectsFromArray:collectionArray];
        
        [weakSelf.tableView reloadData];
        [weakSelf.collectionView reloadData];
    }];
   
    
   
}


- (void)requestData:(void(^)(NSArray *tableArray,NSArray *collectionArray,NSError * error))callback
{
 
//    NSDictionary *dic = [HomeData getData];
     NSArray *tableArray = [HomeData getLeftData];
     NSArray *collectionArray =[HomeData getRightData];

     callback(tableArray,collectionArray,nil);
    
//    AVQuery *query = [AVQuery queryWithClassName:@"HomeDadaSource"];
////    [query whereKeyExists:@"table"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//
//        if (error) {
//            callback(nil,nil,error);
//            return ;
//        }
//
//     AVObject *object = objects.firstObject;
//     NSArray *tableArray = [object objectForKey:@"table"];
//     NSArray *collectionArray = [object objectForKey:@"collection"];
//
//     callback(tableArray,collectionArray,nil);
//
//    }];
}


#pragma mark 空白页面代理
//空白页显示图片
//-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"01"];
//}

//空白页显示标题
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc]initWithString:@"网络不通暂无数据，请稍后重试"];
}

//空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
   return [[NSAttributedString alloc]initWithString:@"暂无数据，请稍后重试"];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeLeftCell"];
    
    cell.contentView.backgroundColor = (_selectIndex == indexPath.row)?  [UIColor orangeColor] : [UIColor whiteColor];
    
    cell.contentLabel.text = self.tableViewArray[indexPath.row];

    return cell;
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
    return self.tableViewArray.count;
//    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.collectionViewArray[section];
    return array.count;
//     return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.collectionViewArray[indexPath.section];
    
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5;
    
    cell.contentLabel.text = array[indexPath.row];

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
    
   UIColor *color = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    header.imageView.image = [UIImage imageWithColor:color];
    header.imageView.contentMode = UIViewContentModeScaleToFill;
    header.contentLabel.text = [NSString stringWithFormat:@"%@",self.tableViewArray[indexPath.section]];
    
    
    return header;
}

//Header 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 44);
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
    

    
    return CGSizeMake((collectionView.size.width -layout.sectionInset.left - layout.sectionInset.right - (line-1)*itemSpace)/line, 44);
}


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
            else if (indexPath.item == 9)
            {
//                vc = [RATreeViewController new];
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
               MovieFileOutputController *VC = [[MovieFileOutputController alloc]init];
                [self presentViewController:VC animated:YES completion:nil];

            }else if (indexPath.item == 2)
            {
                CustomVideoController *VC = [[CustomVideoController alloc]init];
                [self presentViewController:VC animated:YES completion:nil];
                
            }else if (indexPath.item == 3)
            {
                vc = [kStory instantiateViewControllerWithIdentifier:@"AddVideoController"];
            }else if (indexPath.item == 4)
            {
                VideoRecordController *VC = [[VideoRecordController alloc]init];
                [self presentViewController:VC animated:YES completion:nil];
                
            }else if (indexPath.item == 5)
            {
                
                vc = [kStory instantiateViewControllerWithIdentifier:@"CaptureController"];
            }
        }
            break;
        case 5:
        {
            if (indexPath.item == 0)
            {
                vc = [[TakePhotoController alloc]init];
            }else if (indexPath.item == 1)
            {
               vc = [[GPUImageController alloc]init];
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
            if (indexPath.item == 0) {
                
                vc = [MVVM_Controller new];
                vc.navigationItem.title = @"MVVM";
                
            }else if (indexPath.item == 1){
                
                vc = [MVPController new];
                vc.navigationItem.title = @"MVP";
            }
            
            
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
            }else if (indexPath.item == 2)
            {
                vc = [AdapterViewController new];
                vc.navigationItem.title = @"适配器模式";
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
            }else if (indexPath.item == 4)
            {
                vc = [BuryViewController new];
                vc.navigationItem.title = @"埋点";
            }else if (indexPath.item == 5)
            {
                vc = [ContainerViewController new];
                vc.navigationItem.title = @"ChildVC";
            }
        }
            break;
            case 23:
        {
            vc = [KVOViewController new];
        }
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];

}


@end
