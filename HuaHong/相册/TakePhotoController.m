//
//  TakePhotoController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/4.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "TakePhotoController.h"
#import <Photos/Photos.h>
#import "PhotoListController.h"

@interface TakePhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

static NSString *cellId = @"CollectionId";

@implementation TakePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.collectionView];
    
}

-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((kScreenWidth-20)/3.0, 120);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
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
    return self.dataArr.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:cell.contentView.bounds];
    [cell.contentView addSubview:imageview];
    
    if (indexPath.item == self.dataArr.count) {
        imageview.image = [UIImage imageNamed:@"AddPic"];
    }else
    {
        imageview.image = [self.dataArr objectAtIndex:indexPath.item];
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.dataArr.count)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
                
                return ;
            }
            
            [self takePhoto:UIImagePickerControllerSourceTypeCamera];

            
            
        }];
        
        UIAlertAction *singlePhoto = [UIAlertAction actionWithTitle:@"从相册单选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO) {
                
                return ;
            }
            
            [self takePhoto:UIImagePickerControllerSourceTypePhotoLibrary];
//            [self takePhoto:UIImagePickerControllerSourceTypeSavedPhotosAlbum];//时刻

            
        }];
        
        UIAlertAction *PHPhotoLibrary = [UIAlertAction actionWithTitle:@"从相册多选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO) {
                
                return ;
            }
            
            [self getAllPhotos];
            
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:takePicture];
        [alert addAction:singlePhoto];
        [alert addAction:PHPhotoLibrary];

        [alert addAction:cancel];

        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
        HHPhotoBrowserController *vc = [[HHPhotoBrowserController alloc]initWithImageArray:self.dataArr.copy currentPage:indexPath.item];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)takePhoto:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    imagePick.sourceType = sourceType;
    imagePick.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:imagePick animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *origeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.dataArr addObject:origeImage];
    
    [self.collectionView reloadData];
}

#pragma mark - 图片多选
-(void)getAllPhotos
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied) {
            NSLog(@"用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关");
           
        }else if (status == PHAuthorizationStatusRestricted){
            NSLog(@"家长控制,不允许访问");
        }else if (status == PHAuthorizationStatusNotDetermined){
            NSLog(@"用户还没有做出选择");
            //            [[PHPhotoLibrary sharedPhotoLibrary]registerChangeObserver:self];
        }else if (status == PHAuthorizationStatusAuthorized){
            NSLog(@"用户允许当前应用访问相册");
            
            PhotoListController *choiseVC = [[PhotoListController alloc]init];
            choiseVC.maxImageCount = 9;
            [choiseVC setFinishBlock:^(NSMutableArray *selectPhotoArr) {
               
                [self.dataArr addObjectsFromArray:selectPhotoArr];
                [self.collectionView reloadData];
            }];
             
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:choiseVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];

}


@end
