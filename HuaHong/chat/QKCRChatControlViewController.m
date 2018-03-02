//
//  QKCRChatControlViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/28.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "QKCRChatControlViewController.h"
#import "XTSegmentControl.h"
#import <iCarousel.h>

#define kSegmentHeight 50
@interface QKCRChatControlViewController ()<UITableViewDataSource,UITableViewDelegate,iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) XTSegmentControl *mySegmentControl;
@property (strong, nonatomic) iCarousel *myCarousel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sectionData;
@end

@implementation QKCRChatControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指挥监控中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mySegmentControl];
    [self.view addSubview:self.myCarousel];

    
    
    
}


-(NSMutableArray *)sectionData
{
    if (!_sectionData) {
        _sectionData = [NSMutableArray array];
    }
    
    return _sectionData;
}
#pragma mark - 添加segmentControl
-(XTSegmentControl *)mySegmentControl
{
    __weak typeof(self) wealSelf = self;
    if (_mySegmentControl == nil)
    {
        
        _mySegmentControl = [[XTSegmentControl alloc]initWithFrame:CGRectMake(0, 64, self.view.width, kSegmentHeight) Items:@[@"111",@"222",@"333"] selectedBlock:^(NSInteger index) {
            
            [wealSelf.myCarousel scrollToItemAtIndex:index animated:YES];

        }];
        
        _mySegmentControl.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    return _mySegmentControl;
}
-(iCarousel *)myCarousel
{
    if (_myCarousel == nil) {
        _myCarousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, _mySegmentControl.bottom, self.view.width, self.view.height-_mySegmentControl.bottom)];
        _myCarousel.dataSource = self;
        _myCarousel.delegate = self;
        _myCarousel.decelerationRate = 1.0;
        _myCarousel.scrollSpeed = 1.0;
        _myCarousel.type = iCarouselTypeLinear;
        _myCarousel.pagingEnabled = YES;
        _myCarousel.clipsToBounds = YES;
        _myCarousel.bounceDistance = 0.2;
        _myCarousel.backgroundColor = [UIColor clearColor];
    }
    
    return _myCarousel;
}


#pragma mark iCarouselDataSource
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 3;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    self.tableView = (UITableView *)view;
    
//       v = [[UIView alloc]initWithFrame:self.myCarousel.bounds];
//        v.backgroundColor =         [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    
        return self.tableView;
    
    
}

#pragma mark iCarouselDelegate
-(void)carouselDidScroll:(iCarousel *)carousel{
    if (_mySegmentControl)
    {
        float offset = carousel.scrollOffset;
        if (offset > 0)
        {
            [_mySegmentControl moveIndexWithProgress:offset];
        }
    }
}
-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    
//    [self.tableView reloadData];
    
    
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.myCarousel.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerNib:[UINib nibWithNibName:@"QKCRIndicateCell" bundle:nil] forCellReuseIdentifier:@"QKCRIndicateCell"];
//        [_tableView registerClass:[QKCRIndicateHeadView class] forHeaderFooterViewReuseIdentifier:headIdentifier];
        
//        _tableView.tableFooterView = [UIView new];
//        _tableView.estimatedRowHeight = 80;
//        _tableView.backgroundColor =         [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        
    }
    
    
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

@end
