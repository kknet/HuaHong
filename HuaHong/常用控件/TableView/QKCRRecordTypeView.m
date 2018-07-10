//
//  QKCRRecordTypeView.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/27.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "QKCRRecordTypeView.h"

#define kHeight 300 //背景height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface QKCRRecordTypeView()
@property (nonatomic,strong) UIView *maskView;//半透明遮罩
@property (nonatomic,strong) UIView *bjView;//背景view
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *line;
//@property (nonatomic,strong) UIButton *startBtn;
//@property (nonatomic,strong) UIButton *endBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@end
@implementation QKCRRecordTypeView

+(instancetype)shared
{
    QKCRRecordTypeView *instance = [[QKCRRecordTypeView alloc]init];
    
    return instance;
    
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setUpUI];
    }
    
    return self;
}

-(void)setUpUI
{
    [self addSubview:self.maskView];
    [self addSubview:self.bjView];
    [self.bjView addSubview:self.titleLabel];
    [self.bjView addSubview:self.line];

    [self creatCenterContent];
    [self.bjView addSubview:self.cancelBtn];
    
}

-(UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kHeight)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
    }
    
    return _maskView;
}
-(UIView *)bjView
{
    if (_bjView == nil) {
        _bjView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kHeight)];
        _bjView.backgroundColor = [UIColor whiteColor];
    }
    
    
    return _bjView;
}
-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.text = @"选择录音类型";
    }
    
    return _titleLabel;
}

-(UIView *)line
{
    if (_line == nil) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom, kScreenWidth, 0.5)];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _line;
}

//创建中间内容（开始语，结束语，示例label）
-(void)creatCenterContent
{
    UIImage *startImage = [UIImage imageNamed:@"start"];
    UIImage *endImage = [UIImage imageNamed:@"end"];
    CGFloat margin = (kScreenWidth * 0.5 - startImage.size.width) * 0.5;
    
    for (int i = 0; i < 2; i++) {
        
        //创建两个button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth/2 * i + margin, self.line.bottom+30, startImage.size.width, startImage.size.height);
        btn.layer.cornerRadius = startImage.size.width * 0.5;
        btn.layer.masksToBounds = YES;
        [self.bjView addSubview:btn];

        
        //创建两个label
        CGFloat width = kScreenWidth/2-30;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 * i + 20, btn.bottom+15, width, 0)];
        label.numberOfLines = 0;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12.0];
        [self.bjView addSubview:label];


        if (i == 0)
        {
            [btn setImage:startImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
            label.text = @"示例：今天是星期一，我是青客首席执行官金光杰，现在开始分公司点名";
        }else
        {
            [btn setImage:endImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
            label.text = @"示例：今天是一周的第一天，祝你开单顺利";



        }
        
        
        //重新设置高度
        CGFloat lableHeight = [NSString CalculateStringHeightWithString:label.text Width:label.width Font:label.font];
        CGRect frame = label.frame;
        frame.size.height = lableHeight;
        label.frame = frame;
        
        
    }
}
-(UIButton *)cancelBtn
{
    if (_cancelBtn == nil)
    {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, kHeight-50, kScreenWidth, 50);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTintColor:[UIColor whiteColor]];
        [_cancelBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:172/255.0 blue:130/255.0 alpha:1.0];
    }
    
    return _cancelBtn;
}
-(void)show
{
    [UIView animateWithDuration:0.25 animations:^{
        
        _bjView.frame = CGRectMake(0, kScreenHeight-kHeight, kScreenWidth, kHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:self];

    }];
}

-(void)removeAction
{
    [UIView animateWithDuration:0.25 animations:^{
        
        _bjView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kHeight);

        [self removeFromSuperview];

    }];


}

-(void)startAction
{
}

-(void)endAction
{

}


@end
