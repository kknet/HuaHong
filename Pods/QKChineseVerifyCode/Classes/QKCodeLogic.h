//
//  QKCodeLogic.h
//  Code
//
//  Created by Sunny on 25/4/18.
//  Copyright © 2018年 Sunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKCodeLogic : NSObject

/**
 随机数
 
 @param biggestNum 最大的随机数  1-100，最大的随机数是 100
 @param num 随机数的 个数，比如想要6个随机数 0-99，从 0开始
 @return 得到的随机数的数组
 */
+(NSArray *)randomWithBiggestNum:(NSInteger)biggestNum Num:(NSInteger )num;
@end
