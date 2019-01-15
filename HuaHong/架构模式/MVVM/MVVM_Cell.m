//
//  MVVM_Cell.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVM_Cell.h"
#import "MVVM_Model.h"

@interface MVVM_Cell()
@property (nonatomic,weak) UIImageView* imageView;
@property (nonatomic,weak) UILabel* titleLabel;
@property (nonatomic,strong) MVVM_Model *model;
@end

@implementation MVVM_Cell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    UIImageView* imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(imageView.superview);
        make.height.equalTo(imageView.mas_width);
    }];
    self.imageView = imageView;
//    self.imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//    [[tap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//        _model.number++;
//    }];
//    [self.imageView addGestureRecognizer:tap];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom);
        make.bottom.equalTo(self.contentView);
    }];
    self.titleLabel = label;
    
    
}

- (void)prepareForReuse
{
    self.imageView.image = nil;
    self.titleLabel.text = @"";
}

//模型渲染
- (void)renderWithModel:(id)model
{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.images[@"large"]?:nil]];
    self.titleLabel.text = _model.title?:@"";
    self.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.number];
}

//cell标识
+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass(self.class);
}

@end
