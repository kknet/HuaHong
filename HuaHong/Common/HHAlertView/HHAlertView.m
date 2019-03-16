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
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIButton *singleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;

@end
@implementation HHAlertView

/** 此处不适合单例创建，每次都需重新初始化 */
//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [super allocWithZone:zone];
//    });
//
//    return instance;
//}
//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//   __block id obj;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        obj = [HHAlertView sharedAlertView];
//    });
//
//    return obj;
//}

//- (id)copyWithZone:(NSZone *)zone
//{
//    return [HHAlertView sharedAlertView];
//}
+ (instancetype)sharedAlertView
{
    static HHAlertView *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
        instance = [[nib instantiateWithOwner:nil options:nil]lastObject];
//    });
    
    return instance;
}

//在awakeFromNib之前调用，可以对xib文件的初始化作代码上的调整
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    self.leftButton.layer.borderWidth = 1;
    self.leftButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.titleLabel setCornerRadius:10 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    self.forbiddenEmoji = YES;
    self.textView.delegate = self;
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [self addGestureRecognizer:tap];

    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {

        [self endEditing:YES];
    }];
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
    
    if (_leftBlock) {
        _leftBlock(_textView.text);
    }
    
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:0];
    }
}

/** 确定 */
- (IBAction)sureAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
    
    if (_rightBlock) {
        _rightBlock(_textView.text);
    }
    
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:1];
    }
}

/** 设置标题 */
- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

/** 展示的文字内容 */
- (void)setMessage:(NSString *)message
{
    _message = message;
    self.textView.text = message;
    
    /** 设置行间距 段间距 */
    [self setLineSpace:klineSpace ParagraphSpace:kparagraphSpace TextAlignment:self.textView.textAlignment];
    
    /** 根据内容适应高度 */
    [self contentSizeFit];
    
    [self setNeedsLayout];

}

/** 设置左按钮标题 */
- (void)setLeftBtnTitle:(NSString *)leftBtnTitle
{
    NSString *desc = [NSString stringWithFormat:@"%@左按钮标题不能为空",NSStringFromClass([self class])];
    NSAssert(leftBtnTitle && leftBtnTitle.length, desc);
    
    _leftBtnTitle = leftBtnTitle;
    [_leftButton setTitle:leftBtnTitle forState:UIControlStateNormal];
}

/** 设置右按钮标题 */
- (void)setRightBtnTitle:(NSString *)rightBtnTitle
{
    NSString *desc = [NSString stringWithFormat:@"%@右按钮标题不能为空",NSStringFromClass([self class])];
    NSAssert(rightBtnTitle && rightBtnTitle.length, desc);
    
    _rightBtnTitle = rightBtnTitle;
    [_rightButton setTitle:rightBtnTitle forState:UIControlStateNormal];
}

/** 设置单按钮标题 */
- (void)setSingleBtnTitle:(NSString *)singleBtnTitle
{
    NSString *desc = [NSString stringWithFormat:@"%@单按钮标题不能为空",NSStringFromClass([self class])];
    NSAssert(singleBtnTitle && singleBtnTitle.length, desc);
    
    _singleBtnTitle = singleBtnTitle;
    [_singleButton setTitle:singleBtnTitle forState:UIControlStateNormal];
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

/** 根据内容适应高度 */
- (void)contentSizeFit
{
    CGFloat maxHeight = kScreenHeight - 64*2 - (_titleLabel.height+_rightButton.height+40);
    CGSize maxSize = CGSizeMake(_textView.width, maxHeight);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    CGFloat minHeight = MAX(newSize.height, 60);
    _contentHeight.constant =  MIN(minHeight, maxHeight);

    /** 上下居中 */
    if (newSize.height <= self.textView.frame.size.height)
    {
        /** 这里不能使用self.textView.frame.size.height，why？*/
        CGFloat offsetY = (_contentHeight.constant - newSize.height)/2;
        offsetY += self.textView.textContainerInset.top;
        UIEdgeInsets offset = UIEdgeInsetsMake(offsetY, 0, -offsetY, 0);
        [self.textView setTextContainerInset:offset];
    }
    
    self.textView.scrollEnabled = newSize.height > maxHeight;
}

/** 设置为单个按钮 */
- (void)setSingleButton
{
    _leftButton.hidden = _rightButton.hidden = YES;
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

#pragma mark - UITextViewDelegate
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (self.forbiddenEmoji)
    {
        //限制苹果系统输入法  禁止输入表情
        
        /** 方法一 无效果 */
//        if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
//            return NO;
//        }
        
        /** 方法二 无效果 */
//        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
//            return NO;
//        }
        
        /** 方法三 有部分效果 */
        if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
            return NO;
        }
    }
   
    return YES;
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
