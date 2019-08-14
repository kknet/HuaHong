//
//  KVOViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/10/10.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "KVOViewController.h"
#import "NSObject+KVO.h"

@interface KVOViewController ()
@property (nonatomic,strong) Model *model;
@property (nonatomic,strong) NSMutableArray *arrayM;
@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _model = [Model new];
    _model.name = @"";
    
//    [self systemKVO];
    
//    [self FBKVO];
    
//    [self racKVO];
    
    [self myKVO];
    
}

- (void)systemKVO
{
    [_model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew |
     NSKeyValueObservingOptionOld context:@"参数"];
}

- (void)myKVO
{
    [_model hhaddObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew |
     NSKeyValueObservingOptionOld context:@"参数"];
}

- (void)FBKVO
{
    /** 方式一 */
    [self.KVOController observe:_model keyPath:@"name" options:NSKeyValueObservingOptionNew |
    NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {

        NSLog(@"\n object:%@\n change:%@,\n observer:%@",object,change,observer);
    }];
    
//    [self.KVOController observe:_model keyPaths:@[@"name"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//
//        NSLog(@"\n object:%@\n change:%@,\n observer:%@",object,change,observer);
//    }];
    
    
    
     /** 方式二 */
//    [self.KVOController observe:_model keyPath:@"name" options:NSKeyValueObservingOptionNew |
//     NSKeyValueObservingOptionOld action:@selector(ObserveAction:)];
    
//    [self.KVOController observe:_model keyPaths:@[@"name"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld action:@selector(ObserveAction:)];
    
    
    /** 方式三 */
//    [self.KVOController observe:_model keyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"canshu"];
    
//    [self.KVOController observe:_model keyPaths:@[@"name"] options:NSKeyValueObservingOptionNew |
//     NSKeyValueObservingOptionOld context:@"canshu"];
    
}

- (void)ObserveAction:(id)change
{
    NSLog(@"FBKVO被触发:%@",change);
}

- (void)racKVO
{
    /** 方式一 ：刚进来就会监听初始值*/
//    [[_model rac_valuesForKeyPath:@"name" observer:self]subscribeNext:^(id  _Nullable x) {
//        NSLog(@"x:%@",x);
//    }];
    
    /** 方式二 */
    [_model rac_observeKeyPath:@"name" options:NSKeyValueObservingOptionNew |
     NSKeyValueObservingOptionOld observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {

         /**
          * value:第几次改变
          * change:新旧值
          * causedByDealloc:0未知
          * affectedOnlyLastComponent:1未知
          */
         NSLog(@"\n value:%@\n change:%@,",value,change);
     }];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"\n keyPath:%@\n object:%@\n change:%@,\n context:%@",keyPath,object,change,context);
}

- (void)dealloc
{
//    [_model removeObserver:self forKeyPath:@"name"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static int i = 0;
    i++;
    
    _model.name = [NSString stringWithFormat:@"%d",i];
    
    //可变数组发生变化
    [self mutableArrayValueForKey:@"arrayM"][0] = @(1);
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:0];
    //person.num  num是arrayM里面元素的属性
    [self.arrayM addObserver:self toObjectsAtIndexes:indexSet forKeyPath:@"num" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}
@end
