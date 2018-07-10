//
//  JSViewController.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIWebView+TS_JavaScriptContext.h"

@protocol JSObjcDelegate <JSExport>
- (void)callCamera;
- (void)share:(NSString *)shareInfo;
@end

@interface WebViewVC : UIViewController<UIWebViewDelegate,JSObjcDelegate>

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) UIWebView *webView;


@end
