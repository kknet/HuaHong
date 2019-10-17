//
//  HHSoundPlayer.h
//  HuaHong
//
//  Created by 华宏 on 2019/10/17.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHSoundPlayer : NSObject

/** 播放系统音效*/
+ (void)playSystemSoundWithURL:(NSURL *)url;

/** 播放震动音效*/
+ (void)playAlertSoundWithURL:(NSURL *)url;

/** 清空音效文件的内存*/
+ (void)clearMemory;

@end

NS_ASSUME_NONNULL_END
