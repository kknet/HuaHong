//
//  HHSegmentView.h
//  HuaHong
//
//  Created by 华宏 on 2018/5/8.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHSegmentView;

@protocol HHSegmentViewDelegate <NSObject>
-(void)segmentView:(HHSegmentView *)view clickWhithIndex:(NSInteger)index;
@end

@interface HHSegmentView : UIView

@property (strong, nonatomic) NSArray *itemArr;
@property (weak, nonatomic) id<HHSegmentViewDelegate> delegate;

-(void)setScale:(CGFloat)scale PageIndex:(NSInteger)pageIndx;

@end
