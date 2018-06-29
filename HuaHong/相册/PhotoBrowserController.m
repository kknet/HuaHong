//
//  PhotoBrowserController.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/29.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "PhotoBrowserController.h"

@interface PhotoBrowserController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@end

@class HHPhotoBrowserController;
@implementation PhotoBrowserController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        self.image = image;
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        
        self.scrollView.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.contentSize = self.view.bounds.size;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
        [_scrollView addGestureRecognizer:tap];
    }
    
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc]initWithImage:self.image];
        _imageView.frame = CGRectMake(0, 0, kScreenWidth, self.image.size.height*kScreenWidth/self.image.size.width);
        _imageView.center = self.scrollView.center;
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
        [_imageView addGestureRecognizer:tap];
    }
    
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
