//
//  HHSegmentController.m
//  HuaHong
//
//  Created by 华宏 on 2018/5/8.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHSegmentController.h"
#import "HHSegmentView.h"
@interface HHSegmentController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,HHSegmentViewDelegate>
@property (strong, nonatomic) IBOutlet HHSegmentView *segmentView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *itemArr;
@end

@implementation HHSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemArr = @[@"国际",@"推荐",@"视频",@"热点",@"上海",@"娱乐",@"问答",@"图片",@"科技",@"体育",@"军事",@"推荐",@"视频",@"热点",@"上海",@"娱乐",@"问答",@"图片",@"科技",@"体育",@"军事",@"健康"];
    
    self.segmentView.itemArr = self.itemArr;

    self.segmentView.delegate = self;
}

/** 在布局子视图的时候调用 */
-(void)viewDidLayoutSubviews
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.collectionView collectionViewLayout];
    layout.itemSize = self.collectionView.frame.size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor =         [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    
    UILabel *label = [cell viewWithTag:1];
    label.text = [self.itemArr objectAtIndex:indexPath.item];
    
    return cell;
}

-(void)segmentView:(HHSegmentView *)view clickWhithIndex:(NSInteger)index
{
    self.collectionView.delegate = nil;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    self.collectionView.delegate = self;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //向下取整 （scrollView.contentOffset.x - scrollView.frame.size.width）/ 1
    NSInteger pageIndex = floor(offsetX/scrollView.frame.size.width);
    
    CGFloat scale = (offsetX - pageIndex * scrollView.frame.size.width) / scrollView.frame.size.width;
    
    NSLog(@"offsetX :%f,pageIndex:%ld,scale:%f",offsetX,(long)pageIndex,scale);
    
    [self.segmentView setScale:scale PageIndex:pageIndex+1];
    
    [self.segmentView setScale:1-scale PageIndex:pageIndex];


}


@end
