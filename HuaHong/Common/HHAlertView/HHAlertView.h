//
//  HHAlertView.h
//  TheHousing
//
//  Created by 华宏 on 2019/3/13.
//  Copyright © 2019年 com.qk365. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SureActionBlock)(NSString *message);
@interface HHAlertView : UIView

/** 创建 */
+ (instancetype)sharedAlertView;

/** 展示的文字内容 */
@property (nonatomic,copy) NSString *message;

/** 确定Block */
@property (nonatomic,copy) SureActionBlock sureBlock;

/** 弹出提示框 */
- (void)show;

/** 对齐方式 - 默认居中对齐 */
@property(nonatomic) NSTextAlignment textAlignment;

/** 设置为单个按钮 */
- (void)setSingleButton;

/** 设置输入框可编辑 */
@property(nonatomic,getter=isEditable) BOOL editable;

/** 只有可编辑时，才有placeholder */
@property (nonatomic, copy) NSString *placeholder;

@end

NS_ASSUME_NONNULL_END
