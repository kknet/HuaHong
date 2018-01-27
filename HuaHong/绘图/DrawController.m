//
//  DrawController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/25.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "DrawController.h"
#import <Photos/Photos.h>
@interface DrawController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
/*
    [self drawImage];
*/
//    [self clicpImage];
    
//    [self clicpRingImage];
    
//    [self waterMark];
    
    [self screenShot];
}

/**
 * 绘制图片<##>
 */
-(void)drawImage
{
    //开启图片类型的上下文
    //    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
    
    //NO:透明 scale：缩放比 0 : [UIScreen mainScreen].scale
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 300), NO, [UIScreen mainScreen].scale);
    
    
    // 获得当前的上下文(图片类型)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //拼接路径，同时把路径添加到上下文中
    CGContextAddArc(ctx, 150, 150, 100, 0, 2*M_PI, 1);
    
    //渲染
    CGContextStrokePath(ctx);
    
    //通过图片类型的上下文，获取图片对象
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    //    self.imageView.image = image;
    
    //保存到沙盒
    NSString *docpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [docpath stringByAppendingPathComponent:@"aaa.png"];
    
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filePath atomically:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *imagedata = [fileManager contentsAtPath:filePath];
    self.imageView.image = [UIImage imageWithData:imagedata];
}

/**
 * 裁剪图片
 */
-(void)clicpImage
{
    UIImage *originImage = [UIImage imageNamed:@"MyRoom"];
    
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, originImage.size.width*0.5, originImage.size.height*0.5, MIN(originImage.size.width*0.5, originImage.size.height*0.5), 0, 2*M_PI, 1);
    CGContextClip(ctx);
    [originImage drawAtPoint:CGPointZero];
//    [originImage drawInRect:CGRectMake(0, 0, originImage.size.width, originImage.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = image;

    //保存到相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

//裁剪一个带圆环的图片
-(void)clicpRingImage
{
    UIImage *originImage = [UIImage imageNamed:@"MyRoom"];
    CGFloat margin = 10;
    
    CGSize ctxSize = CGSizeMake(MIN(originImage.size.width, originImage.size.height)+margin*2, MIN(originImage.size.width, originImage.size.height)+margin*2);
    UIGraphicsBeginImageContextWithOptions(ctxSize, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(ctxSize.width*0.5, ctxSize.height*0.5);
    
    CGFloat radius = (ctxSize.width-margin)*0.5;//圆环半径
    CGContextAddArc(ctx, center.x, center.y, radius, 0, 2*M_PI, 1);
    CGContextSetLineWidth(ctx, margin);
    [[UIColor orangeColor] set];
    CGContextStrokePath(ctx);
    
    CGContextAddArc(ctx, center.x, center.y, ctxSize.width*0.5 -margin, 0, 2*M_PI, 1);
    CGContextClip(ctx);
    [originImage drawAtPoint:CGPointMake(margin, margin)];
    

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.imageView.image = image;
//    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
    
}

-(void)waterMark
{
    UIImage *originImage = [UIImage imageNamed:@"MyRoom"];
    NSString *waterMarkText = @"水印文字";
    UIImage *waterMarkImage = [UIImage imageNamed:@"JKNotifier_default_icon"];
    
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0);
    
    //画大图
    [originImage drawInRect:CGRectMake(0, 0, originImage.size.width, originImage.size.height)];
    
    //画文字
   [waterMarkText drawInRect:CGRectMake(0, 0, originImage.size.width, originImage.size.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    //画小图
    [waterMarkImage drawAtPoint:CGPointMake(originImage.size.width-waterMarkImage.size.width-5, originImage.size.height-waterMarkImage.size.height-5)];
    
    UIImage *nweImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.imageView.image = nweImage;
}

-(void)screenShot
{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:ctx];
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = image;
    
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
}
@end
