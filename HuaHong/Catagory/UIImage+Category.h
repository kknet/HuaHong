//
//  UIImage+Category.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/21.
//  Copyright © 2018年 huahong. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)

/** 根据颜色生成图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 裁剪 */
- (UIImage*)imageCutSize:(CGRect)rect;

/** 缩放 */
- (UIImage*)imageScaleSize:(CGSize)size;

/** 旋转 */
- (UIImage*)imageRotateInDegree:(float)degree;

/** 水印 */
- (UIImage *)waterMark:(UIImage *)logoImage WaterString:(NSString *)text;

/** 剪裁成圆形 */
- (UIImage *)imageClipCircle;

/** 方向校正 */
+ (UIImage*)fixOrientation:(UIImage*)aImage;

/** 得到Video的第一帧 */
+ (UIImage*)getThumbnail:(NSURL*)videoURL;

+(UIImage*)scaleImg:(UIImage*)org maxsize:(CGFloat)maxsize; //缩放图片

+(UIImage*)scaleImg:(UIImage*)org maxsizeW:(CGFloat)maxW; //缩放图片,,最大多少

@end

NS_ASSUME_NONNULL_END
