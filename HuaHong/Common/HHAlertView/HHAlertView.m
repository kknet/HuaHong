//
//  HHAlertView.m
//  TheHousing
//
//  Created by 华宏 on 2019/3/13.
//  Copyright © 2019年 com.qk365. All rights reserved.
//

#import "HHAlertView.h"

//行间距
#define klineSpace 3
//段间距
#define kparagraphSpace 4
@interface HHAlertView()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIButton *singleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;

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
    
    self.textView.delegate = self;
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [self addGestureRecognizer:tap];

    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {

        [self endEditing:YES];
    }];
}

/** 创建 */
+ (instancetype)sharedAlertView
{
    static HHAlertView *instance = nil;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
    instance = [[nib instantiateWithOwner:nil options:nil]lastObject];
    return instance;
}

/** 弹出提示框 */
- (void)show
{
    [UIView animateWithDuration:0.25 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}

/** 取消 */
- (IBAction)cancelAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
         [self removeFromSuperview];
    }];
}

/** 确定 */
- (IBAction)sureAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
    
    if (_sureBlock) {
        _sureBlock(_textView.text);
    }
}

/** 展示的文字内容 */
- (void)setMessage:(NSString *)message
{
    if (message == nil || message.length == 0) {
        return;
    }
    
    self.textView.text = message;
    
    /** 设置行间距 段间距 */
    [self setLineSpace:klineSpace ParagraphSpace:kparagraphSpace TextAlignment:self.textView.textAlignment];

    [self contentSizeFit];
    
    [self setNeedsLayout];

}

/** 设置行间距 段间距 */
- (void)setLineSpace:(CGFloat)lineSpace ParagraphSpace:(CGFloat)paragraphSpace TextAlignment:(NSTextAlignment)textAlignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.paragraphSpacing = paragraphSpace;
    paragraphStyle.alignment = textAlignment;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
    NSAttributedString *attributeText = [[NSAttributedString alloc]initWithString:self.textView.text attributes:attributes];
    
    self.textView.attributedText = attributeText;
}

- (void)contentSizeFit
{
    CGSize maxSize = CGSizeMake(_textView.width, CGFLOAT_MAX);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    _contentHeight.constant =  MAX(newSize.height, 60);

    /** 上下居中 */
    if (self.textView.contentSize.height <= self.textView.frame.size.height)
    {
        /** 这里不能使用self.textView.frame.size.height，why？*/
        CGFloat offsetY = (_contentHeight.constant - newSize.height)/2;
        offsetY += self.textView.textContainerInset.top;
        UIEdgeInsets offset = UIEdgeInsetsMake(offsetY, 0, -offsetY, 0);
        [self.textView setTextContainerInset:offset];
    }
}
/** 设置为单个按钮 */
- (void)setSingleButton
{
    _cancelButton.hidden = _sureButton.hidden = YES;
    _singleButton.hidden = NO;
    
}

/** 对齐方式 */
- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textView.textAlignment = textAlignment;
}

/** 设置输入框可编辑 */
- (void)setEditable:(BOOL)editable
{
    if (editable)
    {
        self.textView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        self.textView.scrollEnabled = editable;
        self.textView.textAlignment = NSTextAlignmentLeft;
    }

    self.textView.editable = editable;

}

/** 只有可编辑时，才有placeholder */
- (void)setPlaceholder:(NSString *)placeholder
{
    if (self.textView.editable)
    {
        self.textView.placeholder = placeholder;
    }
    
}
/** 开始编辑，弹框升高，避免键盘遮挡 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
     _centerY.constant = -100;
}

/** 结束编辑，弹框恢复居中对齐 */
- (void)textViewDidEndEditing:(UITextView *)textView
{
     _centerY.constant = 0;
}


/**
 //系统弹框自动换行
 UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
 
 [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
 
 [self submitData];
 }]];
 
 [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 
 }]];
 
 
 UIView *subView1 = alertCtrl.view.subviews[0];
 UIView *subView2 = subView1.subviews[0];
 UIView *subView3 = subView2.subviews[0];
 UIView *subView4 = subView3.subviews[0];
 UIView *subView5 = subView4.subviews[0];
 UILabel *messageLab = subView5.subviews[2];
 messageLab.textAlignment = NSTextAlignmentLeft;
 
 NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
 style.lineSpacing = lineSpace;
 style.paragraphSpacing = paragraphSpace;
 NSDictionary *attributes = @{NSParagraphStyleAttributeName:style};
 messageLab.attributedText = [[NSAttributedString alloc]initWithString:messageLab.text attributes:attributes];
 
 [self presentViewController:alertCtrl animated:YES completion:nil];
 
 */

@end
