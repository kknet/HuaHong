//
//  BaseViewController.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/24.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (strong, nonatomic) NSMutableArray<NSURLSessionTask *> *requestTasks;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;


//    //导航栏黑色
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    
//    //关闭导航栏半透明效果
//    self.navigationController.navigationBar.translucent = NO;
//    
//    //状态栏白色
////    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
//
//    //返回按钮文字
//    self.navigationController.navigationBar.topItem.title = @"返回";
//    
//    //返回按钮颜色
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    
//    //标题颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
//    
//    //导航栏颜色
//    self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
//    
//    self.navigationItem.title = @"title";
    
    /**
     * 1.在 viewDidLoad方法中，不能使用superView，因为view的get方法还没有走完，肯定没有添加到其他视图上//superview:(null)
     * 2.在init方法中 不应该出现 self.view 。否则数据还没有加载，就已经调用了viewDidLoad
     */
    
    NSLog(@"superview:%@",self.view.superview);
    
    
    //    self.navigationController.hidesBarsOnSwipe = YES;
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *title = NSLocalizedString(@"title", @"注释");
}

// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton
{
    return YES;
}

// 导航栏是否消失
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

//后台拉取回调
-(void)completationHandler:(void (^)(UIBackgroundFetchResult))completationHandler
{
    NSLog(@"UIBackgroundFetchResultNewData");
    completationHandler(UIBackgroundFetchResultNewData);
}

//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return YES;
//}


- (NSMutableArray<NSURLSessionTask *> *)requestTasks
{
    if (_requestTasks == nil) {
        _requestTasks = [NSMutableArray array];
    }
    
    return _requestTasks;
}

//将task添加到数组中，待页面消失时，统一释放
- (void)addRequestTask:(NSURLSessionTask *)task
{
    if (task == nil || ![task isKindOfClass:[NSURLSessionTask class]]) {
        return;
    }
    
    [self.requestTasks addObject:task];
}

//取消并移除指定的网络请求
- (void)removeRequestTask:(NSURLSessionTask *)task
{
    if (task == nil || ![task isKindOfClass:[NSURLSessionTask class]]) {
        return;
    }
    
    if (task.state == NSURLSessionTaskStateRunning || task.state == NSURLSessionTaskStateSuspended) {
        [task cancel];
    }
    
    task = nil;
}

//取消并移除所有的网络请求
- (void)cancelAllRequestTask
{
    if (self.requestTasks.count <= 0) {
        return;
    }
    
    for (NSURLSessionTask *task in self.requestTasks) {
        if (task.state == NSURLSessionTaskStateRunning || task.state == NSURLSessionTaskStateSuspended) {
            [task cancel];
        }
    }
    
    [self.requestTasks removeAllObjects];
    
    if (_requestTasks.count <= 0) {
        NSLog(@"取消并移除了所有的网络请求");
    }else{
       NSLog(@"requestTasks:%@",_requestTasks);
    }
    
}

//页面消失时，统一释放
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self cancelAllRequestTask];
}

//MARK: - other
-(void)setImage:(UIImage *)image
{
    self.view.layer.contents = (__bridge id)(image.CGImage);

}
@end
