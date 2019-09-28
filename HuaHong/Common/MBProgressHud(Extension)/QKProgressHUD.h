//
//  QKProgressHUD.h
//  TheHousing
//
//  Created by qk-huahong on 2019/7/12.
//  Copyright © 2019 com.qk365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface QKProgressHUD : NSObject

/**
 信息提示
 
 @param message 提示信息
 @param view 加载到哪个view，（nil == window）
 */

//MARK: - 提醒信息
+ (void)showMessage:(NSString *_Nonnull)message toView:(UIView  *_Nullable)view;

//MARK: - 成功信息
+ (void)showSuccess:(NSString *_Nonnull)message toView:(UIView *_Nullable)view;

//MARK: - 错误信息
+ (void)showError:(NSString *_Nonnull)message toView:(UIView *_Nullable)view;

//MARK: - 显示加载框
+ (void)showLoading:(NSString *_Nonnull)message toView:(UIView *_Nullable)view;

//MARK: - 隐藏加载框
+ (void)hideHUDForView:(UIView *_Nullable)view;

@end

NS_ASSUME_NONNULL_END
