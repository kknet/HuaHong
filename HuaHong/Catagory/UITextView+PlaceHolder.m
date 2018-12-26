//
//  UITextView+PlaceHolder.m
//  HuaHong
//
//  Created by 华宏 on 2018/12/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>

static const void *placeholderKey;
@interface UITextView ()
@property (nonatomic,strong) UILabel *placeholderLabel;
@end

@implementation UITextView (PlaceHolder)

+ (void)load
{
    [super load];
    
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")), class_getInstanceMethod(self.class, @selector(layoutSubviews_swizzle)));
    
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")), class_getInstanceMethod(self.class, @selector(dealloc_swizzle)));

//    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")), class_getInstanceMethod(self.class, @selector(setText_swizzle:)));

    
}

- (void)layoutSubviews_swizzle
{
    if (self.placeholder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - self.layer.borderWidth*2;
        CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.placeholderLabel.frame = CGRectMake(x, y, width, height);
        
    }
    
    [self layoutSubviews_swizzle];
}

- (void)dealloc_swizzle
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self dealloc_swizzle];
}

//- (void)setText_swizzle:(NSString *)text
//{
//    [self setText_swizzle:text];
//    if (self.placeholder) {
//        [self updatePlaceHolder];
//    }
//}

- (NSString *)placeholder
{
//    return self.placeholder;
    return objc_getAssociatedObject(self, &placeholderKey);
}

- (void)setPlaceholder:(NSString *)placeholder
{
//    self.placeholder = placeholder;
    objc_setAssociatedObject(self, &placeholderKey, placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self updatePlaceHolder];
}

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderLabel.textColor = placeholderColor;
}
- (void)updatePlaceHolder
{
    if (self.text.length) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }
    
    self.placeholderLabel.font = self.font?self.font:[self defaultFont];
    self.placeholderLabel.textAlignment = self.textAlignment;
    self.placeholderLabel.text = self.placeholder;
    [self insertSubview:self.placeholderLabel atIndex:0];
    
}

- (UILabel *)placeholderLabel
{
    UILabel *placeholderLabel = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!placeholderLabel) {
        placeholderLabel = [[UILabel alloc]init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(placeholderLabel), placeholderLabel, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return placeholderLabel;
}

- (UIFont *)defaultFont
{
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textView = [[UITextView alloc]init];
        textView.text = @" ";
        font = textView.font;
    });
    
    return font;
}
@end
