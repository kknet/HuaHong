//
//  HHPageControl.m
//  HuaHong
//
//  Created by 华宏 on 2018/7/7.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "PageControlVC.h"

@interface PageControlVC ()
@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation PageControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageControl.hidesForSinglePage = YES;
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
//    这个属性如果设置为YES，点击时并不会改变控制器显示的当前页码点，必须手动调用- (void)updateCurrentPageDisplay; 这个方法，才会更新。
    pageControl.defersCurrentPageDisplay = YES;
    [pageControl updateCurrentPageDisplay];
    
    //通过页数得到控制器大小
    CGSize size = [pageControl sizeForNumberOfPages:1];
    NSLog(@"size:%@",NSStringFromCGSize(size));
    
    [pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
}

- (void)pageControlAction:(UIPageControl *)pageControl
{
    NSLog(@"currentPage:%ld",(long)pageControl.currentPage);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.pageControl.currentPage == 4) {
        self.pageControl.currentPage = 0;
    }else
    {
        self.pageControl.currentPage += 1;
    }
    
}
@end
