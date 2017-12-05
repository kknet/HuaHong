//
//  PhotoListController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/4.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "PhotoListController.h"
#import <Photos/Photos.h>
#import "PhotoListCell.h"

@interface PhotoListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *allPhotoArr;
@property (nonatomic,strong) NSMutableArray *selectPhotoArr;

@end

static NSString *cellId = @"CollectionId";

@implementation PhotoListController

-(NSMutableArray *)selectPhotoArr
{
    if (_selectPhotoArr == nil) {
        _selectPhotoArr = [NSMutableArray array];
    }
    
    return _selectPhotoArr;
}

-(NSMutableArray *)allPhotoArr
{
    if (_allPhotoArr == nil) {
        _allPhotoArr = [NSMutableArray array];
    }
    
    return _allPhotoArr;
}
-(void)done
{
    if (_finishBlock) {
        _finishBlock(_selectPhotoArr);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];

    [self.view addSubview:self.collectionView];

    dispatch_async(dispatch_get_main_queue(), ^{
        // 列出所有相册智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        if (smartAlbums.count != 0) {
            
            //获取资源时的参数
            PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
            //按时间排序
            allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            //所有照片
            PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
            
            
            for (NSInteger i = 0; i < allPhotos.count; i++) {
                
                PHAsset *asset = allPhotos[i];
                if (asset.mediaType == PHAssetMediaTypeImage)
                {
                  [self.allPhotoArr addObject:asset];
                    
                    
                }
                
            }
            
            [self.collectionView reloadData];
        }
    });

}

-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((kScreenWidth-30)/4.0, (kScreenWidth-30)/4.0);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PhotoListCell class] forCellWithReuseIdentifier:cellId];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allPhotoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    PhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.signImage.image = [UIImage imageNamed:@"wphoto_select_no"];

    CGFloat scale = [UIScreen mainScreen].scale;
    [self getChoosePicPHImageWithasset:[self.allPhotoArr objectAtIndex:indexPath.item] viewSize:CGSizeMake((kScreenWidth-30)/4.0*scale, (kScreenWidth-30)/4.0*scale) handle:^(UIImage *image) {
        cell.photoView.image = image;
    }];

    
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectPhotoArr.count < self.maxImageCount)
    {
        PhotoListCell *cell = (PhotoListCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.signImage.image = [UIImage imageNamed:@"wphoto_select_yes"];
        
        [self getChoosePicPHImageWithasset:[self.allPhotoArr objectAtIndex:indexPath.item] viewSize:self.view.bounds.size handle:^(UIImage *image) {
            
            [self.selectPhotoArr addObject:image];
        }];
        
    }else
    {
        NSString *message = [NSString stringWithFormat:@"不能超过%ld张",(long)_maxImageCount];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
   
}

//-(void)getsuolueImageWhithAsset:(PHAsset *)asset viewSize:(CGSize)viewSize handle:(Hanele)handle
//{
//    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc]init];
//    [imageManager requestImageForAsset:asset
//                            targetSize:viewSize
//                           contentMode:PHImageContentModeDefault
//                               options:nil
//                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//
//                             handle(result);
//
//                         }];
//}

-(void)getChoosePicPHImageWithasset:(PHAsset *)asset viewSize:(CGSize)viewSize handle:(Hanele)handle

{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = true;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
    };
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:viewSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        
        handle(result);
    }];
}

@end
