//
//  NetworkTools.h
//  HuaHong
//
//  Created by 华宏 on 2018/10/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

@interface NetworkTools : NSObject

//1.block作为属性
@property (nonatomic,copy) void(^block)(void);
-(void)touch;

//2.block作为方法的参数！
-(void)loadData:(void(^)(NSString *html))finished;

//3.block作为返回值
- (void(^)(int))run;
@end
