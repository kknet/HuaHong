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

+ (instancetype)sharedAlertView;

@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) SureActionBlock sureBlock;
- (void)show;

@end

NS_ASSUME_NONNULL_END
