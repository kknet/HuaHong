//
//  HHPhotoBrowserController.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/29.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHPhotoBrowserController.h"
#import "PhotoContainerController.h"

@interface HHPhotoBrowserController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong) NSMutableArray *containerControllers;

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


- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.height-30, self.view.width, 30)];
        _pageControl.hidesForSinglePage = true;
        _pageControl.pageIndicatorTintColor = UIColor.grayColor;
        _pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.backgroundColor = UIColor.clearColor;
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pageControl;
}

- (void)pageControlChanged:(UIPageControl *)sender
{
//    UIViewController *visibleViewController = self.pageViewController.viewControllers[0];
//    NSUInteger currentIndex = [self.containerControllers indexOfObject:visibleViewController];
    
    
    NSLog(@"changedIndex:%ld",(long)sender.currentPage);
    

    NSUInteger changedIndex = sender.currentPage;

    NSArray *viewControllers = [NSArray arrayWithObject:[self.containerControllers objectAtIndex:changedIndex]];

    if (changedIndex > self.currentPage) {
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];

    }
    
    
}

- (UIPageViewController *)pageViewControl
{
    if (!_pageViewController)
    {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey:@(0)};
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.view.frame = self.view.bounds;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.view.backgroundColor = UIColor.clearColor;

        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [_pageViewController didMoveToParentViewController:self];
        
        [self.view addSubview:self.pageControl];
//        [self.view sendSubviewToBack:_pageViewController.view];
        
    }
    
    return _pageViewController;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentPage - 1 < 0) {
        return nil;
    }
    
    PhotoContainerController *vc = [self.containerControllers objectAtIndex:self.currentPage - 1];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    if (self.currentPage + 1 >= self.containerControllers.count) {
        return nil;
    }
    
    PhotoContainerController *vc = [self.containerControllers objectAtIndex:self.currentPage + 1];
    return vc;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.containerControllers.count;
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
    self.currentPage = [self.containerControllers indexOfObject:vc];
}

// 跳转动画完成时触发，配合上面的代理方法可以定位到具体的跳转界面，此方法有利于定位具体的界面位置
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    self.pageControl.currentPage = self.currentPage;

}
- (void)setImageArray:(NSArray<UIImage *> *)imageArray
{
    _imageArray = imageArray;
    
    [imageArray enumerateObjectsUsingBlock:^(UIImage * image, NSUInteger idx, BOOL * _Nonnull stop) {
        
       PhotoContainerController *vc = [[PhotoContainerController alloc]initWithImage:image];
        [self.containerControllers addObject:vc];
    }];
    
    UIViewController *currentVC = [self.containerControllers objectAtIndex:self.currentPage];
    [self.pageViewControl setViewControllers:@[currentVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageControl.numberOfPages = imageArray.count;
    self.pageControl.currentPage = self.currentPage;
}

- (NSMutableArray *)containerControllers
{
    if (!_containerControllers) {
        _containerControllers = [NSMutableArray array];
    }
    return _containerControllers;
}


@end
