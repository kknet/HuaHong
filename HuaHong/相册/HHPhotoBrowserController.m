//
//  HHPhotoBrowserController.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/29.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHPhotoBrowserController.h"
#import "PhotoBrowserController.h"

@interface HHPhotoBrowserController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIPageViewController *pageViewControl;
@property (nonatomic,strong) NSMutableArray *controllerArrayM;

@property (nonatomic,strong) NSArray<UIImage *> *imageArray;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation HHPhotoBrowserController

- (instancetype)initWithImageArray:(NSArray <UIImage *>*)imageArray currentPage:(NSInteger)currentPage
{
    self = [super init];
    if (self) {
        
        self.currentPage = currentPage;
        self.imageArray = imageArray;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor orangeColor];
//    self.navigationController.navigationBar.hidden = YES;
    
}

- (UIPageViewController *)pageViewControl
{
    if (!_pageViewControl)
    {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey:@(0)};
        _pageViewControl = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewControl.view.frame = self.view.bounds;
        _pageViewControl.delegate = self;
        _pageViewControl.dataSource = self;
        
        [self addChildViewController:_pageViewControl];
        [self.view addSubview:_pageViewControl.view];
        [_pageViewControl didMoveToParentViewController:self];
        
    }
    
    return _pageViewControl;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentPage - 1 < 0) {
        return nil;
    }
    
    PhotoBrowserController *vc = [self.controllerArrayM objectAtIndex:self.currentPage - 1];
//    vc.image = [self.imageArray objectAtIndex:self.currentPage - 1];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    if (self.currentPage + 1 >= self.controllerArrayM.count) {
        return nil;
    }
    
    PhotoBrowserController *vc = [self.controllerArrayM objectAtIndex:self.currentPage + 1];
//    vc.image = [self.imageArray objectAtIndex:self.currentPage + 1];
    return vc;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.controllerArrayM.count;
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.currentPage;
}

#pragma mark - UIPageViewControllerDelegate
//跳转动画开始时触发，利用该方法可以定位将要跳转的界面
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    UIViewController *vc = pendingViewControllers.firstObject;
    self.currentPage = [self.controllerArrayM indexOfObject:vc];
}

// 跳转动画完成时触发，配合上面的代理方法可以定位到具体的跳转界面，此方法有利于定位具体的界面位置
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}


//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    return UIPageViewControllerSpineLocationNone;
//}
//
//-(UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//-(UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController
//{
//    return UIInterfaceOrientationPortrait;
//}

- (void)setImageArray:(NSArray<UIImage *> *)imageArray
{
    _imageArray = imageArray;
    
    [imageArray enumerateObjectsUsingBlock:^(UIImage * image, NSUInteger idx, BOOL * _Nonnull stop) {
        
       PhotoBrowserController *vc = [[PhotoBrowserController alloc]initWithImage:image];
        [self.controllerArrayM addObject:vc];
    }];
    
    UIViewController *vc = [self.controllerArrayM objectAtIndex:self.currentPage];
    /** 当前页的vc，不是全部vc */
    [self.pageViewControl setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (NSMutableArray *)controllerArrayM
{
    if (!_controllerArrayM) {
        _controllerArrayM = [NSMutableArray array];
    }
    
    return _controllerArrayM;
}


@end
