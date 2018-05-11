//
//  QKCodeLogic.m
//  Code
//
//  Created by Sunny on 25/4/18.
//  Copyright © 2018年 Sunny. All rights reserved.
//

#import "QKCodeLogic.h"

@implementation QKCodeLogic


/**
 随机数

 @param biggestNum 最大的随机数  1-100，最大的随机数是 100
 @param num 随机数的 个数，比如想要6个随机数 0-99，从 0开始
 @return 得到的随机数的数组
 */
+(NSArray *)randomWithBiggestNum:(NSInteger)biggestNum Num:(NSInteger )num{
    /** 获取6个不相同的随机数 */
    NSMutableArray *indexTmpMuArr = [[NSMutableArray alloc] init];
    for (int i=0; i<num; ) {
        NSInteger random = arc4random() % biggestNum;
        NSString *randomStr = [NSString stringWithFormat:@"%zi",random];
        if (![indexTmpMuArr containsObject:randomStr]) {
            [indexTmpMuArr addObject:randomStr];
            i++;
        }
    }
    return [indexTmpMuArr copy];
}
@end
