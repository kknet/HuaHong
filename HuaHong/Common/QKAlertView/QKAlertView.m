//
//  QKAlertView.m
//  QK365
//
//  Created by wangxiaoli on 2017/11/29.
//  Copyright © 2017年 qk365. All rights reserved.
//

#define kRatioWidth 320
#define kSelfRatio self.width/kRatioWidth
#define kSelfViewRatio self.view.width/kRatioWidth
#define kWindowRatio kScreenWidth/kRatioWidth
#define kSpace 20

#import "QKAlertView.h"
@interface QKAlertView ()
{
    NSMutableArray *_titleArray; //button的title数组
    void(^_callback)(QKAlertView *alertView,NSInteger buttonIndex);
    NSString *_title;
    NSString *_message;
    NSInteger _countDownTime;
    UILabel *_msgLabel;
    UILabel *_titleLabel;
    dispatch_source_t _timer;
}

@end

@implementation QKAlertView

+ (instancetype)sharedAlertView
{
    static dispatch_once_t once;
    static QKAlertView *alert;
    dispatch_once(&once, ^{
        alert = [[QKAlertView alloc] init];
    });
    return alert;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self) {
        [self configBGView];
    }
    return self;
}

- (void)configBGView
{
    UIView *shadowView = [[UIView alloc] initWithFrame:self.bounds];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0.3;
    [self addSubview:shadowView];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];

}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message buttonClickback:(void(^)(QKAlertView *alertView,NSInteger buttonIndex))callback buttonTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION
{
//    self = [super initWithFrame:];[AppDelegate sharedAppDelegate].window.bounds

    _titleArray = [[NSMutableArray alloc] init];
    _title = title;
    _callback = callback;
    _message = message;
    
    va_list argList;
    va_start(argList, otherBtnTitles);

    if(otherBtnTitles) {
        [_titleArray addObject:otherBtnTitles];
        
        id temp;
        while((temp = va_arg(argList, id))) {
            [_titleArray addObject:temp];
        }
    }
    
    va_end(argList);
    [self configUI];
}

- (void)alertWithTitle:(NSString *)title
                      message:(NSString *)message
              buttonClickback:(void(^)(QKAlertView *alertView,NSInteger buttonIndex))callback
                    countDown:(NSInteger)countDownTime buttonTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION
{

    _titleArray = [[NSMutableArray alloc] init];
    _title = title;
    _message = message;
    _callback = callback;
    _countDownTime = countDownTime;

    va_list argList;
    va_start(argList, otherBtnTitles);

    if(otherBtnTitles) {
        [_titleArray addObject:otherBtnTitles];
        //临时指针变量
        id temp;
        while((temp = va_arg(argList, id))) {
            [_titleArray addObject:temp];
            NSLog(@"%@",_titleArray);
        }
    }
    
    va_end(argList);
    
    [self configUI];
    [self createTimer];
    
}

- (void)configUI
{
    // 设置背影半透明
   /*
    */
     
    if (_alertView == NULL) {
        _alertView = [[UIView alloc] init];
        [self addSubview:_alertView];
    }
    CGSize titleSize = [UILabel labelHeightFit:@{NSFontAttributeName:Font(16)} width:kScreenWidth text:_title];
    CGSize msgSize = [UILabel labelHeightFit:@{NSFontAttributeName:Font(15)} width:kScreenWidth text:_message];

    CGFloat btnWidth = (self.width - 2 * kSpace)/_titleArray.count;
    CGFloat btnHeight = 40;
    CGFloat itemMargin = 10;
    CGFloat topSpace = 20;
    CGFloat alertHeight;
    CGFloat titleHeight;
    
    
    if (_title != nil) {
        alertHeight = topSpace + titleSize.height + msgSize.height + btnHeight + 2 * itemMargin + 2 * kSpace;
        titleHeight = titleSize.height + kSpace;
        
    } else {
        titleHeight = titleSize.height;
        alertHeight = topSpace + titleSize.height + msgSize.height + btnHeight + 2 * itemMargin + kSpace;
    }
    

    
    
    NSLog(@"titleSize.height = %f",titleSize.height);
    NSLog(@"msgSize.height = %f",msgSize.height);
    NSLog(@"btnHeight = %f",btnHeight);
    NSLog(@"topSpace = %f",topSpace);
    NSLog(@"itemMargin = %f",itemMargin);

    _alertView.frame = CGRectMake(20, (kScreenHeight - alertHeight)/2 , self.width - 40, alertHeight);
    _alertView.layer.cornerRadius = 6;
    _alertView.backgroundColor =[UIColor whiteColor];
    _alertView.layer.masksToBounds = YES;
    NSLog(@"_alertViewFrame:%@",NSStringFromCGRect(_alertView.frame));
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, topSpace, _alertView.width - 2 * kSpace, titleHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = COLOR(36, 37, 39, 1);
    _titleLabel.text = _title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = Font(16);

    [_alertView addSubview:_titleLabel];
    
    
    
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, itemMargin + _titleLabel.bottom, _alertView.width - 2 * kSpace, msgSize.height + kSpace)];
    _msgLabel.backgroundColor = [UIColor clearColor];
    _msgLabel.textColor = COLOR(36, 37, 39, 1);
    _msgLabel.text = _message;
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.numberOfLines = 0;
    _msgLabel.font = Font(15);
    [_alertView addSubview:_msgLabel];
    
    for (int j = 0; j < [_titleArray count]; j++){
        NSString *s = _titleArray[j];
        NSLog(@"s : %@",s);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderWidth = 1;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = COLOR(237, 237, 240, 1).CGColor;
        button.frame = CGRectMake(j*btnWidth, _msgLabel.bottom + itemMargin, btnWidth, btnHeight);
        NSLog(@"btnWidth = %f",btnWidth);
        NSLog(@"_alertView.width = %f",_alertView.width);
        NSLog(@"_msgLabel.bottom = %f",_msgLabel.bottom);
        NSLog(@"_alertView.height = %f",_alertView.height);
        NSLog(@"itemMargin = %f",itemMargin);
        NSLog(@"frme:%@",NSStringFromCGRect(button.frame));
        button.layer.cornerRadius = 1;
        button.layer.masksToBounds = YES;
        button.tag = j;
        [button setTitle:s forState:UIControlStateNormal];
        [button setTitleColor:COLOR(74, 167, 133, 1) forState:UIControlStateNormal];
        [_alertView addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    

}

- (void)show
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:[QKAlertView sharedAlertView]]) {
            [[UIApplication sharedApplication].keyWindow addSubview:[QKAlertView sharedAlertView]];
        }
    });

}
#pragma mark --创建定时器
- (void)createTimer
{
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(_timer, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(_timer, ^{
        _countDownTime--;
        if (_countDownTime == 0) {
            dispatch_cancel(_timer);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _msgLabel.text = [NSString stringWithFormat:@"%ldS倒计时",_countDownTime];
        });
    });
    //由于定时器默认是暂停的，需要启动一下
    //启动定时器
    dispatch_resume(_timer);
}

- (void)buttonClick:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;

    if (_callback) {
        _callback(weakSelf,sender.tag);
    }
    [self dismiss];
}

- (void)dismiss
{
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf removeFromSuperview];
    });
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self dismiss];

}

@end
