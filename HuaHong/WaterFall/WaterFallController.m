//
//  WaterFallController.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/30.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "WaterFallController.h"
#import "WaterFallLayout.h"

@interface WaterFallController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *imageArr;

@end
static NSString *cellId = @"cellID";

@implementation WaterFallController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"功能";
    
    _imageArr = @[@"Survey",@"Customer",@"MyRoom",@"CustomerOrder",@"Rank",@"CheckOut",@"Healthy",@"Tools",@"",@"LearningZone"];
    
    [self.view addSubview:self.collectionView];
    
}

-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        WaterFallLayout *layout = [[WaterFallLayout alloc]init];
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        layout.itemCount = 10;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        layout.minimumLineSpacing = margin;
        layout.minimumInteritemSpacing = margin;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kNavBarHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
    }
    
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{
    return 10;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-margin*3)/2;
    CGFloat bigHeight = width-15;
    CGFloat smallHeight = (bigHeight-margin)/2;
    
    if (indexPath.item ==0 ||indexPath.item ==2 || indexPath.item ==4 ||indexPath.item ==8) {
        return CGSizeMake(width, bigHeight);
        
    }else
    {
        return CGSizeMake(width, smallHeight);
        
    }
    
    return CGSizeMake(width, bigHeight);
    
}

////每一个分组的上左下右间距
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(20, 15, 20, 15);
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 5.0;
    
    cell.contentView.backgroundColor = [UIColor orangeColor];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.contentView.bounds];
    imageView.image = [UIImage imageNamed:[_imageArr objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:imageView];
    
    //    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    //    label.text=[NSString stringWithFormat:@"这是第%ld个cell",(long)indexPath.row];
    //    label.backgroundColor=[UIColor clearColor];
    //    [cell.contentView addSubview:label];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
    
    //    UpLoadViewController *upLoadVC = [[UpLoadViewController alloc]init];
    //    [self presentViewController:upLoadVC animated:YES completion:nil];
    
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    _collectionView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, collectionView.bounds.size.height);
}
#pragma mark-设置cell即将出现的方法  做3D动画出场
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 0.1);
    [UIView animateWithDuration:0.6 animations:^{
        
        cell.layer.transform=CATransform3DMakeScale(1, 1, 1);
    }];
    
}

@end


