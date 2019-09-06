//
//  H264DecodeTool.h
//  HuaHong
//
//  Created by qk-huahong on 2019/8/30.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

@protocol  H264DecodeDelegate <NSObject>

//回调sps和pps数据
- (void)gotDecodedFrame:(CVImageBufferRef )imageBuffer;

@end

@interface H264DecodeTool : NSObject

-(BOOL)initH264Decoder;

//解码nalu
-(void)decodeNalu:(uint8_t *)frame size:(uint32_t)frameSize;

- (void)endDecode;

@property (weak, nonatomic) id<H264DecodeDelegate> delegate;

@end
