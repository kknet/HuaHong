//
//  VideoTopView.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/6.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VideoTopViewClickTypeClose,
    VideoTopViewClickTypeFlash,
    VideoTopViewClickTypeSwitchCamera,
} VideoTopViewClickType;

@protocol VideoTopViewDelegate<NSObject>

-(void)VideoTopViewClickHandler:(VideoTopViewClickType)type;
@end

@interface VideoTopView : UIView

@property (nonatomic,weak) id<VideoTopViewDelegate> delegate;

@end
