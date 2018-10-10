//
//  FlyWeightController.m
//  HuaHong
//
//  Created by 华宏 on 2018/10/10.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "FlyWeightController.h"
#import "Flower.h"
#import "Factory.h"

@interface FlyWeightController ()

@end

@implementation FlyWeightController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    Factory *factory = [Factory new];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < 10000; i++) {
        
        FlowerType type = arc4random_uniform(kTotalColors);
        Flower *flower = [factory flowerWithType:type];
        
        /** 使用享元模式，可节省内存 */
        [arrayM addObject:flower];

    }
    
}



@end
