//
//  WKWebViewVC.m
//  HuaHong
//
//  Created by 华宏 on 2018/7/10.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "WKWebViewVC.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface WKWebViewVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic, strong)UIProgressView *progressView;
@end

@implementation WKWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setBarButtonItem];
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.allowsInlineMediaPlayback = YES;
    
    config.preferences = [[WKPreferences alloc] init];
    
    config.preferences.minimumFontSize = 30;
    
    /** 是否允许JS交互，默认YES */
//    config.preferences.javaScriptEnabled = YES;
    
//    config.processPool = [[WKProcessPool alloc] init];

//    /** 是否允许JS自动打开窗口，默认NO */config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    config.userContentController = [[WKUserContentController alloc] init];
    
    /** 注入JS */
    NSString *javaScriptSource = @"alert(\"WKUserScript注入js\");";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScriptSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];// forMainFrameOnly:NO(全局窗口)，yes（只限主窗口）
    [config.userContentController addUserScript:userScript];
    
    /** JS调OC */
    [config.userContentController addScriptMessageHandler:self name:@"share"];
    
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, self.progressView.bottom, self.view.width, self.view.height-self.progressView.bottom) configuration:config];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"h5.html" withExtension:nil];

  [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    [webView loadFileURL:url allowingReadAccessToURL:url];
    
    
    [self.view addSubview:webView];
    
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    self.webView = webView;
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKWebView WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    //    NSLog(@"urlString=%@",urlString);
    // 用://截取字符串
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if ([urlComps count]) {
        // 获取协议头
        NSString *protocolHead = [urlComps objectAtIndex:0];
        NSLog(@"protocolHead:%@",protocolHead);
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark -
/** OC调JS */
- (void)callJSAction
{
    [_webView evaluateJavaScript:@"showAlert('huahong')" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
}

/** JS调OC WKScriptMessageHandler */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    if ([message.name isEqualToString:@"share"]) {
        
        NSLog(@"%@", message.body);
        
    }
}

- (void)setBarButtonItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"调JS" style:UIBarButtonItemStylePlain target:self action:@selector(callJSAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, kNavBarHeight, kScreenWidth, 2);
        _progressView.backgroundColor = [UIColor blueColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0, 1.5);
        [self.view addSubview:_progressView];
    }
    
    return _progressView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
    }
}
- (void)dealloc
{
    [self.webView.configuration.userContentController removeAllUserScripts];
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
