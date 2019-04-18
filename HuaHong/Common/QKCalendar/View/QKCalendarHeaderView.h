//
//  QKCalendarHeaderView.h
//  QKCalendarHeaderView
//
//  Created by 华宏 on 2019/4/14.
//  Copyright © 2019年  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwithMonthBlock)(void);
@interface QKCalendarHeaderView : UICollectionReusableView

@property(nonatomic,strong)NSString *dateStr;
@property (nonatomic,copy) SwithMonthBlock lastMonthBlock;
@property (nonatomic,copy) SwithMonthBlock nextMonthBlock;

@end

NS_ASSUME_NONNULL_END
