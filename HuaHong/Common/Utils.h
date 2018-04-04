//
//  Utils.h
//  SinaWeibo
//
//  Created by wang xinkai on 15/4/13.
//  Copyright (c) 2015年 wxk. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Utils : NSObject


+(NSString*)formatString:(NSString*)timeString;

+(NSString *)convertToJsonFrom:(id)data;

#pragma mark 方向校正
+ (UIImage*)fixOrientation:(UIImage*)aImage;
@end
