//
//  PullUpRefreshView.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "PullUpRefreshView.h"
#define PullUpRefreshViewHeight 60

typedef NS_ENUM(NSInteger, PullUpRefreshViewStatus) {
    PullUpRefreshViewStatusNormal,
    PullUpRefreshViewStatusPulling,
    PullUpRefreshViewStatusRefreshing
};


@interface PullUpRefreshView()
@property (nonatomic, strong) UIScrollView *scorllView;
//@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) PullUpRefreshViewStatus currentStatus;
@end

@implementation PullUpRefreshView

-(instancetype)initWithFrame:(CGRect)frame
{
    CGRect newFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, PullUpRefreshViewHeight);
    
    self = [super initWithFrame:newFrame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        [self addSubview:self.indicatorView];
        [self addSubview:self.label];
        
        //添加约束
        
        [self addLayoutConstraints];
        
    }
    
    return self;
}

#pragma mark - 添加约束
-(void)addLayoutConstraints
{
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-30]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-15]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

#pragma mark - 添加到父控件时调用
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scorllView = (UIScrollView *)newSuperview;
        
        [self.scorllView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
        [self.scorllView addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];

    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect frame = self.frame;
        if (self.scorllView.contentSize.height > self.scorllView.frame.size.height)
        {
            frame.origin.y = self.scorllView.contentSize.height;

        }else
        {
            frame.origin.y = self.scorllView.frame.size.height;

        }
        self.frame = frame;
    }else if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (self.scorllView.isDragging)
        {
            if (self.scorllView.contentOffset.y + self.scorllView.frame.size.height < self.scorllView.contentSize.height+PullUpRefreshViewHeight && self.currentStatus == PullUpRefreshViewStatusPulling)
            {
                self.currentStatus = PullUpRefreshViewStatusNormal;
                
            }else if (self.scorllView.contentOffset.y + self.scorllView.frame.size.height >= self.scorllView.contentSize.height+PullUpRefreshViewHeight && self.currentStatus == PullUpRefreshViewStatusNormal)
            {
                self.currentStatus = PullUpRefreshViewStatusPulling;

            }
        }else if(self.currentStatus == PullUpRefreshViewStatusPulling)
        {
            self.currentStatus = PullUpRefreshViewStatusRefreshing;
        }
    }
}

-(void)setCurrentStatus:(PullUpRefreshViewStatus)currentStatus
{
    _currentStatus = currentStatus;
    
    switch (_currentStatus) {
        case PullUpRefreshViewStatusNormal:
            self.label.text = @"上拉加载数据";
            if ([self.indicatorView isAnimating]) {
                [self.indicatorView stopAnimating];
            }
            break;
        case PullUpRefreshViewStatusPulling:
            self.label.text = @"释放刷新数据";
            if (![self.indicatorView isAnimating]) {
                [self.indicatorView startAnimating];
            }
            break;
        case PullUpRefreshViewStatusRefreshing:
            self.label.text = @"正在刷新数据...";
            if (![self.indicatorView isAnimating]) {
                [self.indicatorView startAnimating];
            }
            UIEdgeInsets contentInset = self.scorllView.contentInset;
            contentInset.bottom += PullUpRefreshViewHeight;
            
            [UIView animateWithDuration:0.2 animations:^{
                self.scorllView.contentInset = contentInset;

            } completion:^(BOOL finished) {
                if (_pullUpBlock) {
                    _pullUpBlock();
                }
                
            }];
            

            break;
            
        
    }
    
}

-(void)endloadMore
{
    if (_currentStatus == PullUpRefreshViewStatusRefreshing)
    {
        UIEdgeInsets contentInset = self.scorllView.contentInset;
        contentInset.bottom -= PullUpRefreshViewHeight;
        self.scorllView.contentInset = contentInset;

        self.currentStatus = PullUpRefreshViewStatusNormal;
    }
}

-(UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:16];
        _label.text = @"上拉加载更多数据";
        [_label sizeToFit];
        
    }
    
    return _label;
}

-(UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.color = [UIColor whiteColor];
        _indicatorView.hidesWhenStopped = NO;
    }
    
    return _indicatorView;
}

-(void)dealloc
{
    [self.scorllView removeObserver:self forKeyPath:@"contentSize"];
    [self.scorllView removeObserver:self forKeyPath:@"contentOffset"];

}
@end
