//
//  PhotoBrowserController.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/29.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DisMissBlock)(void);
@interface PhotoBrowserController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,copy) DisMissBlock dismissBlock;

@end
