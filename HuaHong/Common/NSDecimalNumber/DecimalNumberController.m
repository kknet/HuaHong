//
//  DecimalNumberController.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "DecimalNumberController.h"
#import "DecimalNumberHelper.h"


@implementation DecimalNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DecimalNumberHelper *helper = [DecimalNumberHelper defaultDecimalNumberHelper];
    
    //加
    NSDecimalNumber *AddNumber = [helper decimalNumberType:DecimalNumberAddType withDecimalNumberA:@"0.98" withDecimalNumberB:@"0.976"];
    NSLog(@"AddNumber = %@",AddNumber.stringValue);
    
    
    //减
    NSDecimalNumber *subtractNum = [helper decimalNumberType:DecimalNumberSubtractType withDecimalNumberA:@"0.98" withDecimalNumberB:@"0.976"];
    NSLog(@"subtractNum = %@",subtractNum.stringValue);
    
    
    //乘
    NSDecimalNumber *multiplyNum = [helper decimalNumberType:DecimalNumberMultiplyType withDecimalNumberA:@"0.98" withDecimalNumberB:@"0.976"];
    NSLog(@"multiplyNum = %@",multiplyNum.stringValue);
    
    
    //除
    NSDecimalNumber *dividNum = [helper decimalNumberType:DecimalNumberDividType withDecimalNumberA:@"0.98" withDecimalNumberB:@"0.976"];
    NSLog(@"dividNum = %@",dividNum.stringValue);
    
    
    //四舍五入,scale保留几位小数
    NSDecimalNumber *roundNum = [helper decimalNumber:@"0.98896" scale:3];
    NSLog(@"roundNum = %@",roundNum.stringValue);
    
    
    //n次方
    NSDecimalNumber *raisNum = [helper decimalNumberType:DecimalNumberRaisType withDecimalNumberA:@"0.98" withPower:2];
    NSLog(@"raisNum = %@",raisNum);
    
    
    //指数运算
    NSDecimalNumber *powerNum = [helper decimalNumberType:DecimalNumberPowerType withDecimalNumberA:@"5.01" withPower:2];
    NSLog(@"powerNum = %@",powerNum);
    
}

@end

