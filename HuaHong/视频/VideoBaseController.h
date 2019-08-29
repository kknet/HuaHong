//
//  BaseVideoController.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoTopView.h"
#import "VideoBottomView.h"
#import "HHVideoManager.h"
#import "VideoRecorder.h"

@interface VideoBaseController : UIViewController<VideoTopViewDelegate,VideoBottomViewDelegate,CAAnimationDelegate>

@property (nonatomic, strong) VideoTopView *topView;
@property (nonatomic, strong) VideoBottomView *bottomView;
//@property (nonatomic,assign) BOOL isRecord;//记录按钮状态
@property (nonatomic,assign) NSInteger timeLengh;//录音时长
@property (nonatomic, assign) BOOL isFront;//是否是前置摄像头


-(void)back;
-(void)switchFlashLight;
/**切换摄像头*/
- (void)switchCamera;

-(void)playVideo:(NSString *)path;
-(void)begainrecord;

-(void)timerFired;
-(void)timerStop;
@end
