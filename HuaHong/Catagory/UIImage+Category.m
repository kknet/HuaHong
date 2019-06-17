//
//  UIImage+Category.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/21.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UIImage+Category.h"
#import <AVFoundation/AVFoundation.h>
//用于图片旋转
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@interface View:UIView
@property (nonatomic,strong) UIImage *image;
@end

@implementation View
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, rect.size.width/2.0, rect.size.height/2.0));
    CGContextClip(context);
    CGContextFillPath(context);
    [_image drawAtPoint:CGPointMake(0, 0)];
    CGContextRestoreGState(context);
}
@end


@implementation UIImage (Category)

/** 根据颜色生成图片 */
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/** 裁剪 */
- (UIImage*)imageCutSize:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallRect = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallRect, subImageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 缩放 */
- (UIImage*)imageScaleSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 旋转 */
- (UIImage*)imageRotateInDegree:(float)degree
{
    size_t width = (size_t)(self.size.width * self.scale);
    size_t height = (size_t)(self.size.height * self.scale);
    size_t bytesPerRow = width * 4;//每行图片字节数
    CGImageAlphaInfo alphaInfo = kCGImageAlphaPremultipliedFirst;
    
    //配置上下文参数
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault | alphaInfo);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), self.CGImage);
    
    //旋转
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(bmContext);
    vImage_Buffer src = {data,height,width,bytesPerRow};
    vImage_Buffer dest = {data,height,width,bytesPerRow};
    Pixel_8888 bgColor = {0,0,0,0};
    vImageRotate_ARGB8888(&src, &dest, NULL, degree, bgColor, kvImageBackgroundColorFill);
    
     //context -> UIImage
    CGImageRef rotateImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *image = [UIImage imageWithCGImage:rotateImageRef scale:self.scale orientation:self.imageOrientation];
    
    return image;
}

/** 水印 */
- (UIImage *)waterMark:(UIImage *)logoImage WaterString:(NSString *)text
{
    UIGraphicsBeginImageContext(self.size);
    
    //绘制logo
    [logoImage drawInRect:CGRectMake(self.size.width-50-10, self.size.height-50-10, 50, 50)];
    
    //绘制文字
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *Attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor redColor]};
    [text drawInRect:CGRectMake(0, 0, self.size.width, 60) withAttributes:Attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 剪裁成圆形 */
- (UIImage *)imageClipCircle
{
    CGFloat imageSizeMin = MIN(self.size.width, self.size.height);
    View *mView = [[View alloc]init];
    mView.image = self;
    UIGraphicsBeginImageContext(CGSizeMake(imageSizeMin, imageSizeMin));
    CGContextRef context = UIGraphicsGetCurrentContext();
    mView.frame = CGRectMake(0, 0, imageSizeMin, imageSizeMin);
    mView.backgroundColor = [UIColor whiteColor];
    [mView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
   方向校正
 1. 先将头部朝上
 2. 将镜像反转
 3. 重新合成输出
 */
+ (UIImage*)fixOrientation:(UIImage*)aImage
{
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage* img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/** 得到Video的第一帧 */
+ (UIImage*)getThumbnail:(NSURL*)videoURL
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    
    NSParameterAssert(asset);
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    
    // 截图的时候调整到正确的方向
    generator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef imageRef = [generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    if (error) {
        return nil;
    }
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return image;
    
}

//缩放图片,,最大多少
+(UIImage*)scaleImg:(UIImage*)org maxsizeW:(CGFloat)maxW
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    
    if( org.size.width > maxW )
    {
        w = maxW;
        h = (w / org.size.width) * org.size.height;
    }
    else
    {
        w = org.size.width;
        h = org.size.height;
        return org;
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}


//缩放图片
+(UIImage*)scaleImg:(UIImage*)org maxsize:(CGFloat)maxsize
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    if( org.size.width > org.size.height )
    {
        if( org.size.width > maxsize )
        {
            w = maxsize;
            h = (w / org.size.width) * org.size.height;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    else
    {
        if( org.size.height > maxsize )
        {
            h = maxsize;
            w = (h / org.size.height) * org.size.width;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}
@end
