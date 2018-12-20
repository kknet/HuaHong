//
//  NetworkTools.h
//  HuaHong
//
//  Created by 华宏 on 2018/10/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

@interface NetworkTools : NSObject

-(void)loadData:(void(^)(NSString *html))finished;

@end
