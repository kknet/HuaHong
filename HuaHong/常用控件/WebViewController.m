//
//  JSViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "WebViewController.h"
//JSContext
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WebViewController

-(void)loadView
{
    self.webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
//    NSURL *url = [NSURL URLWithString:@"http://seller.o2o.zhaioto.com/user/apply"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
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
    //调用JS @"showalert('lq')"
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"test();"];
    NSLog(@"str:%@",str);
    
    //JS调OC
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    context[@"sellerRegister:"]= ^(id str){
        NSLog(@"JS调OC");

    };
}

//发送请求之前，   JS调用OC的代码
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //    <a href="source://showMessage:/helloworld">调用OC的方法</a>
    
    //获取url中的协议
    NSLog(@"%@",request.URL.scheme);
    
    //判断协议是否是自定义协议
    if ([request.URL.scheme isEqualToString:@"source"]) {
        
        NSLog(@"%@",request.URL.pathComponents);
        
        //方法名
        NSString *methodName = request.URL.pathComponents[1];
        //参数
        NSString *param = request.URL.pathComponents[2];
        
        //调用方法
        //把字符串的方法名称 转换成一个selector
        SEL method = NSSelectorFromString(methodName);
        if ([self respondsToSelector:method]) {
            //调用方法
            [self performSelector:method withObject:param];
        }
        
        
        return NO;
    }
    
    //返回no，所有的请求都不执行
    //    return NO;
    return YES;
}

- (void)showMessage:(NSString *)str {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    //弹出的按钮
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"clicker");
    }];
    
    [vc addAction:action];
    
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
