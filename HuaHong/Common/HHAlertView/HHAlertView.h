//
//  HHAlertView.h
//  TheHousing
//
//  Created by 华宏 on 2019/3/13.
//  Copyright © 2019年 com.qk365. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HHAlertView;
@protocol HHAlertViewDelegate <NSObject>

- (void)alertView:(HHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

typedef void(^AlertBlock)(NSString *message);
@interface HHAlertView : UIView

/** 此处不适合单例创建，每次都需重新初始化 */
+ (instancetype)sharedAlertView;

/** 设置标题，只有set，没有get */
@property (nonatomic,copy,nullable) NSString *title;

/** 展示的文字内容 */
@property (nonatomic,copy) NSString *message;

/** 属性文本 */
@property(/*null_resettable*/nonatomic,copy) NSAttributedString *attributedMessage;

/** 确定Block */
@property (nonatomic,copy) AlertBlock rightBlock;

/** 取消Block */
@property (nonatomic,copy) AlertBlock leftBlock;

/** 对齐方式 - 默认居中对齐 */
@property(nonatomic) NSTextAlignment textAlignment;

@property (nonatomic,weak,nullable) id<HHAlertViewDelegate> delegate;

/** 设置为单个按钮 */
- (void)setSingleButton;

/** 设置输入框可编辑 */
@property(nonatomic,getter=isEditable) BOOL editable;

/** 限制字数 */
@property (nonatomic,assign) NSInteger limitCount;

/** 只有可编辑时，才有placeholder */
@property (nonatomic, copy) NSString *placeholder;

/** 是否禁止输入emoj表情😊，默认禁止YES */
@property (nonatomic,assign) BOOL forbiddenEmoji;

/** 设置标题titleColor,backgroundColor */
- (void)setTitleBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;

/** 设置左按钮title,titleColor,backgroundColor,borderColor */
- (void)setLeftButtonTitle:(NSString *)title TitleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor;

/** 设置右按钮title,titleColor,backgroundColor,borderColor */
- (void)setRightButtonTitle:(NSString *)title TitleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor;

/** 设置单按钮title,titleColor,backgroundColor,borderColor */
- (void)setSingleButtonTitle:(NSString *)title TitleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor;

/** 弹出提示框 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
