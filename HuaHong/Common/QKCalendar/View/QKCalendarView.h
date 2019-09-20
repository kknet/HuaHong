//
//  QKCalendarView.h
//  QKCalendarView
//
//  Created by 华宏 on 2019/4/14.
//  Copyright © 2019年  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectBlock) (NSInteger year ,NSInteger month ,NSInteger day);
@interface QKCalendarView : UIView

/*
 * 异常数据
 */
@property(nonatomic,strong)NSArray<NSString *> *unNormalDatas;

/*
 * 异常数据颜色
 */
@property(nonatomic,strong)UIColor *unNormalColor;

/*
 * 当前月的title颜色
 */
@property(nonatomic,strong)UIColor *currentMonthTitleColor;

/*
 * 上月的title颜色
 */
@property(nonatomic,strong)UIColor *lastMonthTitleColor;

/*
 * 下月的title颜色
 */
@property(nonatomic,strong)UIColor *nextMonthTitleColor;

/*
 * 选中的背景颜色
 */
@property(nonatomic,strong)UIColor *selectBackColor;

/*
 * 今日的title颜色
 */
@property(nonatomic,strong)UIColor *todayTitleColor;

/*
 * 选中的是否动画效果
 */
@property(nonatomic,assign)BOOL     isHaveAnimation;


/*
 * 是否禁止手势滚动
 */
@property(nonatomic,assign)BOOL     isCanScroll;

/*
 * 是否显示上月，下月的的数据
 */
@property(nonatomic,assign)BOOL     isShowLastAndNextDate;

//选中的回调
@property(nonatomic,copy)SelectBlock selectBlock;

/*
 * 在配置好上面的属性之后执行
 */
-(void)show;


@end
