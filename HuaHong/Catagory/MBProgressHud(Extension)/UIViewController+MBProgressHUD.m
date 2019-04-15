//
//  UIViewController+MBProgressHUD.m
//  HuaHong
//
//  Created by 华宏 on 2019/4/6.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import "UIViewController+MBProgressHUD.h"
#import "MBProgressHUD+add.h"
#import <objc/runtime.h>

@implementation UIViewController (MBProgressHUD)

+ (void)load
{
    Method viewDidDisappearMethod = class_getInstanceMethod([self class], @selector(viewDidDisappear:));
    Method viewDidDisappear_swizzle = class_getInstanceMethod(self, @selector(viewDidDisappear_swizzle:));
    
    method_exchangeImplementations(viewDidDisappearMethod, viewDidDisappear_swizzle);
}
    
- (void)viewDidDisappear_swizzle:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.view];
    
    [self viewDidDisappear_swizzle:animated];
}

@end
