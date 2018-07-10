//
//  JSViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"调JS" style:UIBarButtonItemStylePlain target:self action:@selector(callJSAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, kScreenHeight-200)];
    self.view = self.webView;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"text.html" withExtension:nil];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    //自动检测电话号码，网址，邮件地址
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //缩放网页
    self.webView.scalesPageToFit = YES;
    
    //让oc调用js的代码
    self.webView.delegate = self;
}


//代理方法
//等待网页加载完成 才能执行js
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [webView stringByEvaluatingJavaScriptFromString:@"showalert('haha')"];

    //JS调OC
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"onClickOC"] = ^(NSString *string){
        NSLog(@"onClickOC==%@",string);
    };
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.jsContext[@"HH"] = self;

    });
    
    
    
    
}

- (void)callJSAction
{
//    [self.jsContext evaluateScript:@"showAlert('huahong')"];

}

#pragma mark - JSObjcDelegate
- (void)callCamera
{
    [UIViewController showAlertWhithTarget:self Title:@"提示" Message:@"callCamera" SureTitle:@"确定" CancelTitle:nil SureAction:^{
        
    } CancelAction:nil];
}

-(void)share:(NSString *)shareInfo
{
    [UIViewController showAlertWhithTarget:self Title:@"提示" Message:shareInfo SureTitle:@"确定" CancelTitle:nil SureAction:^{
        
    } CancelAction:nil];
}



////发送请求之前，   JS调用OC的代码
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    //    <a href="source://showMessage:/helloworld">调用OC的方法</a>
//
//    //获取url中的协议
//    NSLog(@"%@",request.URL.scheme);
//
//    //判断协议是否是自定义协议
//    if ([request.URL.scheme isEqualToString:@"source"]) {
//
//        NSLog(@"%@",request.URL.pathComponents);
//
//        //方法名
//        NSString *methodName = request.URL.pathComponents[1];
//        //参数
//        NSString *param = request.URL.pathComponents[2];
//
//        //调用方法
//        //把字符串的方法名称 转换成一个selector
//        SEL method = NSSelectorFromString(methodName);
//        if ([self respondsToSelector:method]) {
//            //调用方法
//            [self performSelector:method withObject:param];
//        }
//
//
//        return NO;
//    }
//
//    //返回no，所有的请求都不执行
//    //    return NO;
//    return YES;
//}


@end
