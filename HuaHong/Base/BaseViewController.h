//
//  BaseViewController.h
//  HuaHong
//
//  Created by 华宏 on 2017/11/24.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ShouldPopOnBackButton.h"
@interface BaseViewController : UIViewController

//将task添加到数组中，待页面消失时，统一释放
- (void)addRequestTask:(NSURLSessionTask *)task;

//取消并移除指定的网络请求
- (void)removeRequestTask:(NSURLSessionTask *)task;

@end
