//
//  FaceViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/21.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "FaceViewController.h"
#import "FaceppAPI.h"

@interface FaceViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIImageView *imageVIew;

@end

@implementation FaceViewController

-(UIImageView *)imageVIew
{
    if (_imageVIew == nil) {
        _imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(30, 100, kScreenWidth-60, kScreenWidth-60)];
        _imageVIew.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _imageVIew;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    [self.view addSubview:self.imageVIew];
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(selectPhotoClick)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"拍照" style:UIBarButtonItemStylePlain target:self action:@selector(selectCameClick)];
    
    self.navigationItem.rightBarButtonItems = @[leftItem,rightItem];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
}

-(void)selectPhotoClick
{
    //1. 首先判断是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    //2. 创建选择控制器
    UIImagePickerController *picker = [UIImagePickerController new];
    
    //3. 设置类型
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //4. 设置代理
    picker.delegate = self;
    
    //5. 弹出
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)selectCameClick
{
    
    //1. 首先判断是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    //2. 创建选择控制器
    UIImagePickerController *picker = [UIImagePickerController new];
    
    //3. 设置类型
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //4. 设置代理
    picker.delegate = self;
    
    //5. 弹出
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark Picker代理方法
//点击照片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //8. 实现了代理方法一定要取消
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //1. 获取选择的图像
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //orientation 0  --> 在做人脸识别, 一定要方向为0
    
    //2. 校正方向
    image = [Utils fixOrientation:image];
    
    //3. 开始检测
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    //    UIImagePNGRepresentation(<#UIImage * _Nonnull image#>)
    
    //detection/detect    检测一张照片中的人脸信息（脸部位置、年龄、种族、性别等等）
    FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:data];
    
    NSLog(@"result = %@",result);
    
    //4. 获取性别,年龄
    
    NSArray *array = result.content[@"face"];
    if (array.count <= 0) {
        
        return;
    }
    NSDictionary *attributeDict = result.content[@"face"][0][@"attribute"];
    NSString *ageValue = attributeDict[@"age"][@"value"];
    NSString *sexValue = [attributeDict[@"gender"][@"value"] isEqualToString:@"Male"] ? @"男性" : @"女性";
    
    //5. 获取脸部位置 (比例值)
    NSDictionary *positionDict = result.content[@"face"][0][@"position"];
    
    CGFloat h = [positionDict[@"height"] floatValue];
    CGFloat w = [positionDict[@"width"] floatValue];
    CGFloat x = [positionDict[@"center"][@"x"] floatValue] - w * 0.5;
    CGFloat y = [positionDict[@"center"][@"y"] floatValue] - h * 0.5;
    
    //6. 画图 --> 画脸到 image 上
    
    //6.1 开启图像图形上下文
    UIGraphicsBeginImageContextWithOptions( image.size, NO, 0);
    
    //6.2 将原图先绘制到底部, 从(0, 0)点开始绘制
    [image drawAtPoint:CGPointZero];
    
    //6.3 画素材图像到图形上下文中
    UIImage *aImage = [UIImage imageNamed:@"cang"];
    
    // 根据原图的大小比例来计算自己的位置
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    [aImage drawInRect:CGRectMake(x * 0.01 * imageW , y * 0.01 * imageH, w * 0.01 * imageW, h * 0.01 * imageH)];
    
    // 320     50%     160
    //50 * 0.01 * 320   = 160
    
    //6.4 合成新的图像
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //6.5 关闭图像上下文
    UIGraphicsEndImageContext();
    
    //7. 在控制器显示
    
    //删除原有约束,然后重新添加
    
    // 删除原有约束
    [self.imageVIew autoRemoveConstraintsAffectingView];
    
    // 设置居中
    [self.imageVIew autoCenterInSuperview];
    
    // 设置宽高 --> 需要根据图片的比例来确定
    //960 * 1080
    
    // 假如我们需要宽度: 屏幕总宽度
    
    // iPhone5 : 320
    // iPhone6 : 375
    CGFloat scale = newImage.size.width / [UIScreen mainScreen].bounds.size.width;
    
    
    //Dimension : 尺寸 --> 宽高
    [self.imageVIew autoSetDimension: ALDimensionWidth toSize:newImage.size.width / scale];
    [self.imageVIew autoSetDimension:ALDimensionHeight toSize:newImage.size.height / scale];
    
    self.imageVIew.image = newImage;
    
    
}

@end
