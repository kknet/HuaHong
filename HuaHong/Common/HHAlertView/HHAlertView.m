//
//  HHAlertView.m
//  TheHousing
//
//  Created by 华宏 on 2019/3/13.
//  Copyright © 2019年 com.qk365. All rights reserved.
//

#import "HHAlertView.h"

#define klineSpace 8
@interface HHAlertView()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@end
@implementation HHAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.titleLabel setCornerRadius:10 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
}

+ (instancetype)sharedAlertView
{
    static HHAlertView *instance = nil;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
    instance = [[nib instantiateWithOwner:nil options:nil]lastObject];
    return instance;
}

- (void)show
{
    [UIView animateWithDuration:0.25 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}

- (IBAction)cancelAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
         [self removeFromSuperview];
    }];
}

- (IBAction)sureAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
    
    if (_sureBlock) {
        _sureBlock(_message);
    }
}

- (void)setMessage:(NSString *)message
{
    self.textView.text = message;
    
    /** 设置行间距 */
    [self setLineSpace:klineSpace];

    [self setNeedsLayout];

}

/** 设置行间距 */
- (void)setLineSpace:(CGFloat)lineSpace
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = lineSpace;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:style};
    NSAttributedString *attributeText = [[NSAttributedString alloc]initWithString:self.textView.text attributes:attributes];
    
    self.textView.attributedText = attributeText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(_textView.width, CGFLOAT_MAX);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    _contentHeight.constant = newSize.height;
}
@end
