/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
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

@end
