//
//  QKCalendarView.h
//  QKCalendarView
//  Created by 华宏 on 2019/4/14.
//  Copyright © 2019年  All rights reserved.

#import "QKCalendarView.h"
#import "QKCalenderCell.h"
#import "NSDate+Calendar.h"
#import "QKCalendarModel.h"
#import "QKCalendarHeaderView.h"
#import "UIView+Extension.h"

#define kHeaderHeight 80
#define kCellHeight 50

@interface QKCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;//当月的模型集合
@property (nonatomic,strong) NSDate *currentMonthDate;//当月的日期
@property (nonatomic,strong) QKCalendarModel *currentMonthModel;
@property (nonatomic,strong) UISwipeGestureRecognizer *leftSwipe;//左滑手势
@property (nonatomic,strong) UISwipeGestureRecognizer *rightSwipe;//右滑手势

@end
@implementation QKCalendarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        self.currentMonthDate = [NSDate date];
        [self addSwipeGesture];
        self.height = self.collectionView.bottom;
    }
    return self;
}

//初始化默认数据
- (void)initData
{
    self.currentMonthTitleColor = UIColor.blackColor;
    self.lastMonthTitleColor = UIColor.lightGrayColor;
    self.nextMonthTitleColor = UIColor.lightGrayColor;
    self.selectBackColor = UIColor.redColor;
    self.todayTitleColor = UIColor.redColor;
    self.isHaveAnimation = true;
    self.isCanScroll = true;
    self.isShowLastAndNextDate = true;
    
}

- (void)setCurrentMonthDate:(NSDate *)currentMonthDate
{
    _currentMonthDate = currentMonthDate;
    self.currentMonthModel = [[QKCalendarModel alloc]initWithDate:_currentMonthDate];
}

-(void)addSwipeGesture
{
    //添加左滑手势
    self.leftSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.collectionView addGestureRecognizer:self.leftSwipe];
    
    //添加右滑手势
    self.rightSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collectionView addGestureRecognizer:self.rightSwipe];
}

#pragma mark -- 数据以及更新处理--
-(void)show
{
    [self.dataArray removeAllObjects];
    
    NSDate *previousMonthDate = [self.currentMonthDate previousMonthDate:1];
    
    QKCalendarModel *lastMonthModel = [[QKCalendarModel alloc]initWithDate:previousMonthDate];
    
    for (int i = 1; i <= self.currentMonthModel.row * 7; i++) {
        
        QKCalendarModel *model;

        //上个月的日期
        if (i < _currentMonthModel.firstWeekday)
        {
            NSUInteger day = lastMonthModel.totalDays - _currentMonthModel.firstWeekday + i + 1;
            NSDate *date = [self.currentMonthDate previousMonthDate:day];
            model = [[QKCalendarModel alloc]initWithDate:date];
            model.day = lastMonthModel.totalDays - _currentMonthModel.firstWeekday + i + 1;
            model.isLastMonth = YES;
        }
        
        //当月的日期
        if (i >= _currentMonthModel.firstWeekday && i < (_currentMonthModel.firstWeekday + _currentMonthModel.totalDays)) {
            NSUInteger day = i - _currentMonthModel.firstWeekday +1;
            NSDate *date = [self.currentMonthDate currentMonthDate:day];
            model = [[QKCalendarModel alloc]initWithDate:date];
            model.day = day;
            model.isCurrentMonth = YES;
            
        }
        
        //下月的日期
        if (i >= (_currentMonthModel.firstWeekday + _currentMonthModel.totalDays)) {
            NSUInteger day = i - _currentMonthModel.firstWeekday - _currentMonthModel.totalDays +1;
            NSDate *date = [self.currentMonthDate nextMonthDate:day];
            model = [[QKCalendarModel alloc]initWithDate:date];
            model.day = day;
            model.isNextMonth = YES;
            
        }
        
        //配置外面属性
        [self configDayModel:model];
        
        
        [self.dataArray addObject:model];
        
    }
    
    [self.collectionView reloadData];
    
}

-(void)configDayModel:(QKCalendarModel *)model
{
    //配置外面属性
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.currentMonthTitleColor = self.currentMonthTitleColor;
    
    model.lastMonthTitleColor = self.lastMonthTitleColor;
    
    model.nextMonthTitleColor = self.nextMonthTitleColor;
    
    model.selectBackColor = self.selectBackColor;
    
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.todayTitleColor = self.todayTitleColor;
    
    model.isShowLastAndNextDate = self.isShowLastAndNextDate;
    
    
}

/** 是否禁止手势滚动 */
-(void)setIsCanScroll:(BOOL)isCanScroll{
    _isCanScroll = isCanScroll;
    
    self.leftSwipe.enabled = self.rightSwipe.enabled = isCanScroll;
}

//MARK: - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"cell";
    QKCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"LXCalenderCell" bundle:nil];
        cell = [[nib instantiateWithOwner:self options:nil]firstObject];
    }
    
    QKCalendarModel *model = self.dataArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

//MARK: - UICollectionViewDelegate
//Header 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, kHeaderHeight);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        QKCalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.dateStr = [NSString stringWithFormat:@"%ld年%ld月",_currentMonthModel.year,_currentMonthModel.month];
        
        __weak typeof(self) weakSelf = self;
        [headerView setLastMonthBlock:^{
           [weakSelf rightSwipe:nil];
        }];
        
        [headerView setNextMonthBlock:^{
             [weakSelf leftSwipe:nil];
        }];
        return headerView;
    }
    
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    QKCalendarModel *model = self.dataArray[indexPath.row];
    model.isSelected = YES;
    
    [self.dataArray enumerateObjectsUsingBlock:^(QKCalendarModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj != model) {
            obj.isSelected = NO;
        }
    }];
    
    if (self.selectBlock) {
        self.selectBlock(model.year, model.month, model.day);
    }
    
    [collectionView reloadData];
    
}

//MARK: - 懒加载
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        flow.sectionInset = UIEdgeInsetsZero;
        flow.itemSize = CGSizeMake(self.width/7, kCellHeight);
        
        CGFloat height = self.currentMonthModel.row * kCellHeight + kHeaderHeight;
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, height) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"QKCalenderCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"QKCalendarHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}

//MARK: - 手势
//左滑手势
-(void)leftSwipe:(UISwipeGestureRecognizer *)swipe{
    
    self.currentMonthDate = [self.currentMonthDate nextMonthDate:1];
    [self performAnimations:kCATransitionFromRight];
    [self show];
}

//右滑手势
-(void)rightSwipe:(UISwipeGestureRecognizer *)swipe{
    
    self.currentMonthDate = [self.currentMonthDate previousMonthDate:1];
    [self performAnimations:kCATransitionFromLeft];
    
    [self show];
}

//MARK: - 动画
- (void)performAnimations:(NSString *)transition{
    CATransition *catransition = [CATransition animation];
    catransition.duration = 0.5;
    [catransition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    catransition.type = kCATransitionPush;
    catransition.subtype = transition;
    [self.collectionView.layer addAnimation:catransition forKey:nil];
}


@end
