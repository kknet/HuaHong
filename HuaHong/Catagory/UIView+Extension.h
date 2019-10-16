//
//  UIView+Extension.h
//  HuaHong
//
//  Created by 华宏 on 2019/4/6.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (Extension)

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
    

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

/** 设置圆角 */
- (void)setCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners;

- (UIViewController *)viewController;

//判断一个view是否在window上面
-(BOOL)isShowingOnWindow;

-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;

/** 截屏 */
- (UIImage*)takeSnapshot:(CGRect)rect;
 
UINavigationController *selectedNavigationController(void);

//* 边线颜色 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

//* 边线宽度 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

//* 圆角半径 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

//设置渐变色
- (void)setGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
