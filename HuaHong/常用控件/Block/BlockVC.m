//
//  BlockViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "BlockVC.h"
#import "NetworkTools.h"

typedef void(^Block)(NSString *str);
@interface BlockVC ()
@property (nonatomic, strong) NetworkTools *tools;
@property (nonatomic, assign) NSInteger index;//基本数据类型也一样
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) Block block;
@end

@implementation BlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Block";
    
    
    NetworkTools *tools = [[NetworkTools alloc] init];
    _tools = tools;
    
    //
    /**
     * 1.block作为属性
     * 先写setter方法,再触发_block(),这样才有回调
     */
//     [_tools touch];
    
    __block NSString *string = @"testString";
    NSLog(@"Block前：%p",string);
    [_tools setBlock:^{
        string = @"hello wold";
        NSLog(@"Block后：%p",string);
        NSLog(@"block作为属性");
    }];
    
    [_tools touch];//_block()
    
    
 //2.block作为方法的参数！
    _index = 123;
    _text = @"text";
    
    //发起数据
    //1. 没有引起强引用（tools在出了viewDidLoad()方法被释放了）
    
    
        [tools loadData:^(NSString *html) {
    
//            NSLog(@"%@-------------%ld",html,self.index);
    
        }];
    
    
//    //2.
//    //在block中 访问self 会对外部变量做copy操作
//    __weak typeof(self) weakSelf = self; //解决强引用方式
//    //__weak weak 当对象被系统回收的时候  对象的地址会自动指向nil(给nil发送消息，是没问题的)
//
//    self.tools = [[NetworkTools alloc] init];
//    [self.tools loadData:^(NSString *html) {
//
//        NSLog(@"%@-------------%@",html,weakSelf.view);
//        //        NSLog(@"%@-------------%@",html,self.view);
////        NSLog(@"%@-------------%@",html,_arr);
//        [weakSelf setBlock:^(NSString *str) {
//            NSLog(@"%@",str);
//        }];
//    }];
    
    
    
    /**
        self是一个指向实例对象的指针，它的生命周期至少是伴随着当前的实例对象的，所以一旦它和对象之间有循环引用是无法被自动打破的；strongSelf是block内部的一个局部变量，变量的作用域仅限于局部代码，而程序一旦跳出作用域，strongSelf就会被释放，这个临时产生的“循环引用”就会被自动打破
     */
    
    
////    __weak typeof(self) weakSelf = self;
//    @weakify(self);
//    [self setBlock:^(NSString *str) {
//
//        @strongify(self);
////        __strong typeof(weakSelf) strongSelf = weakSelf;
//        NSLog(@"2----%ld",(long)self.index);
//
//        NSLog(@"3----%@",self.text);
//
////        __strong typeof(weakSelf) strongSelf = weakSelf;
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            NSLog(@"2----%ld",(long)self.index);
//
//        });
//    }];
//
//    self.block(@"block");
}

- (void)test{
    NSLog(@"test");
}
-(void)getURLWithString:(NSString *)string block:(id (^)(id obj))block
{
    block(@"hh");
}

//- (void)demo1 {
//
//    id(^block1)() = ^id() {
//
//        return nil;
//    };
//
//    <#returnType#>(^<#blockName#>)(<#parameterTypes#>) = ^(<#parameters#>) {
//        <#statements#>
//    };
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [_tools run];
    _tools.run(3);
}
-(void)dealloc {
    
    NSLog(@"控制器 dealloc");
}


@end
