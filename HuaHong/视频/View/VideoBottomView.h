//
//  VideoBottomView.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/6.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VideoBottomViewClickType){
    VideoBottomViewClickTypeRecord,
    VideoBottomViewClickTypePlay
};

@protocol VideoBottomViewDelegate<NSObject>

-(void)VideoBottomViewClickHandler:(VideoBottomViewClickType)type;
@end

@interface VideoBottomView : UIView

@property (nonatomic,weak) id<VideoBottomViewDelegate> delegate;

@property (nonatomic,copy) NSString *lastVideoPath;

-(void)configVideoThumb:(UIImage *)thumbImage;

-(void)configTimeLabel:(CGFloat)second;


@end
