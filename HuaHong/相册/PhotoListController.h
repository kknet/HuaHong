//
//  PhotoListController.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/4.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishChoiseBlock)(NSMutableArray *selectPhotoArr);
typedef void(^Hanele)(UIImage *image);
@interface PhotoListController : UIViewController

@property (nonatomic,assign) NSInteger maxImageCount;
@property (nonatomic,copy) finishChoiseBlock finishBlock;

@end
