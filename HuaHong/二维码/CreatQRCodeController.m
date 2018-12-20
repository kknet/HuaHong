//
//  CreatQRCodeController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/5.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CreatQRCodeController.h"
#import <Photos/Photos.h>

@interface CreatQRCodeController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CreatQRCodeController

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textField.text = @"http://www.baidu.com";
}
- (IBAction)creatQRCode:(id)sender
{
    if (!_textField.text || !_textField.text.length) {
        return;
    }
    
//    UIImage *image = [self createQRImageWithString:_textField.text QRSize:CGSizeMake(250, 250) QRColor:[UIColor blackColor] bkColor:[UIColor whiteColor]];
    UIImage *image = [self createQRImageWithString:_textField.text QRSize:CGSizeMake(250, 250)];

    if (image) {
        self.imageView.image = image;
    }
}

//方法一 生成二维码 自定义颜色
- (UIImage* )createQRImageWithString:(NSString*)content QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bkColor.CGColor],
                             nil];
    CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

//方法二 生成二维码 默认白色底黑色码
-(UIImage*)createQRImageWithString:(NSString*)content QRSize:(CGSize)size
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];

    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRelease(cgImage);

    return codeImage;
}

- (IBAction)creatBarCode:(id)sender
{
    if (!_textField.text || !_textField.text.length) {
        return;
    }
    
//    UIImage *image = [self createBarCodeImageWithString:_textField.text QRSize:CGSizeMake(250, 150) QRColor:[UIColor blackColor] bkColor:[UIColor whiteColor]];
    UIImage *image = [self createBarCodeImageWithString:_textField.text barSize:CGSizeMake(250, 150)];

    if (image) {
        self.imageView.image = image;
    }
}

//方法一 生成条形码 自定义颜色
-(UIImage* )createBarCodeImageWithString:(NSString*)content QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *barFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [barFilter setValue:stringData forKey:@"inputMessage"];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",barFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bkColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

//方法二 生成条形码 默认白色底黑色码
-(UIImage *)createBarCodeImageWithString:(NSString *)content barSize:(CGSize)size
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *qrImage = filter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRelease(cgImage);

    return codeImage;
}

- (IBAction)longPressAction:(id)sender
{
    if (_imageView.image)
    {
        
        [UIViewController showAlertWhithTarget:self Title:@"提示" Message:@"是否保存到相册？" ClickAction:^(UIAlertController *alertCtrl, NSInteger buttonIndex) {
            [self savedPhotosToAlbum:_imageView.image];
        } CancelTitle:@"取消" OtherTitles:@"确定", nil];
    }
}

//保存到相册 方法一
-(void)saveToPhotoLibrary:(UIImage *)image
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
    }];
}

//保存到相册 方法二
-(void)savedPhotosToAlbum:(UIImage *)image
{
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),@"identifier");


}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error)
    {
        NSLog(@"保存成功:%@",contextInfo);
    }
}
@end
