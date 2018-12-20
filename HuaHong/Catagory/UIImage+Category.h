//
//  UIImage+Category.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/21.
//  Copyright © 2018年 huahong. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)

+ (nullable UIImage *)imageWithColor:(UIColor *)color;

/** 方向校正 */
+ (UIImage*)fixOrientation:(UIImage*)aImage;

/** 得到Video的第一帧 */
+ (UIImage*)getThumbnail:(NSURL*)videoURL;

@end

NS_ASSUME_NONNULL_END
