//
//  MemoryController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/14.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MemoryController.h"

typedef void(^Block)(void);

@interface MemoryController ()

@property (nonatomic, copy) Block block;
@property (nonatomic, strong) NSObject *objc;
@end

@implementation MemoryController

/*
 问题总结：
 一.野指针(EXC_BAD_ACCESS)
 诊断方法：
 1.Malloc Scribble :
 原理：对象释放后在内存上填上不可访问的数据
 步骤：
 (1).选中Edit Scheme；
 (2).Run -> Diagnostics -> Malloc Scribble
 
 2.Malloc Guard Edges:
 边缘保护，分配大容量的内存前后添加保护
 步骤：
 (1).选中Edit Scheme；
 (2).Run -> Diagnostics -> Malloc Guard Edges
 
 3.Guard Malloc
 动态内存分配保护，使用libgmalloc来捕获常见的内存问题，比如缓冲区溢出，为了定位大内存越界访问问题，不过只能在模拟器上使用
 步骤：
 (1).选中Edit Scheme；
 (2).Run -> Diagnostics -> Guard Malloc
 
 4.Zombie Objects
 原理：
 启用了NSZombieEnabled的话，它会用一个僵尸来替换默认的dealloc实现，也就是在引用计数降到0时，该僵尸实现会将该对象转换成僵尸对象。僵尸对象的作用是在你向它发送消息时，它会显示一段日志并自动跳入调试器。
 所以当启用NSZombieEnabled时，一个错误的内存访问就会变成一条无法识别的消息发送给僵尸对象。僵尸对象会显示接受到得信息，然后跳入调试器，这样你就可以查看到底是哪里出了问题。
 所以这时一般崩溃的原因是：调用了已经释放的内存空间，或者说重复释放了某个地址空间。
 步骤：
 (1).选中Edit Scheme；
 (2).Run -> Diagnostics -> Zombie Objects
 
 
 二.内存泄漏
 1.静态分析
 (在程序未运行之前来检查代码是否存在bug。比如，内存泄露、文件资源泄露或访问空指针的数据等)
 手动静态分析：每次都是通过点击菜单栏的Product -> Analyze或快捷键shift + command + b
 自动静态分析：在Build Settings启用Analyze During 'Build'，每次编译时都会自动静态分析
 
 Analyze主要分析以下四种问题：
 （1）逻辑错误：访问空指针或未初始化的变量等；
 （2）内存管理错误：如内存泄漏等；
 （3）声明错误：从未使用过的变量；
 （4）Api调用错误：未包含使用的库和框架。
 
 
 
 2. 启动Instruments
 启动步骤：
 (1)点击Xcode的菜单栏的 Product -> Profile 启动Instruments
 (2)此时，出现Instruments的工具集，选中Leaks子工具点击
 (3)打开Leaks工具之后，点击红色圆点按钮启动Leaks工具，在Leaks工具启动同时，模拟器或真机也跟着启动
 (4)启动Leaks工具后，它会在程序运行时记录内存分配信息和检查是否发生内存泄露。
 
 定位内存泄露:
 (1)首先点击Leak Checks时间条那个红色叉
 (2)然后双击某行内存泄露调用栈，会直接跳到内存泄露代码位置
 参考：http://www.jianshu.com/p/92cd90e65d4c
 
 监测耗时情况：
 当点击Time Profiler应用程序开始运行后.就能获取到整个应用程序运行消耗时间分布和百分比.
 http://www.jianshu.com/p/9ac281228de2
 
 
 内存分配：Allocations
 http://www.jianshu.com/p/b3443352169c
 
 
 
 Separate by Thread :线程分离
 Hide System Libraries:隐藏系统函数
 Invert Call Tree : 从上到下跟踪堆栈信息
 Flatten Recursion: 递归函数, 每个堆栈跟踪一个条目，拼合递归。
 Top Functions:找到最耗时的函数或方法
 
 左边的Show the CPU Data 可以查看每个CPU的消耗情况
 中间的Show the Instruments Data 显示整体的消耗情况
 右边的Show the Thread Data 可以查看每个线程对CPU的消耗情况
 
 Count：设置调用的次数
 Time (ms)：设置耗时范围
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

}

/**
 * 不会内存泄漏，无循环引用
 */
-(void)block1
{
    Block b = ^{
     
        [self method];
    };
    
    b();
}

/**
 * 内存泄漏，循环引用
 */
-(void)block2
{
    self.block = ^{
      
//        [self method];
        
        _objc = [NSObject new];
        
    };
    
    self.block();
}
#pragma mark - Block Bug
-(void)BlockMemoryProblems:(void(^)(void))callBack
{
    callBack();
}

#pragma mark - delegate
-(void)method
{
    NSLog(@"Method");
    
}

#pragma mark - NSArray
//-(void)array_NSDictionary
//{
//    NSMutableArray *datesArray = [[NSMutableArray alloc]init];
//    NSDictionary *dictionary = [[NSDictionary alloc]init];
//    datesArray = [dictionary objectForKey:@"key"];
//}

#pragma mark - 截取部分图像
+(UIImage*)getSubImage:(unsigned long)ulUserHeader
{
    UIImage * sourceImage = [UIImage imageNamed:@"header.png"];
    CGFloat height = sourceImage.size.height;
    CGRect rect = CGRectMake(0 + ulUserHeader*height, 0, height, height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([sourceImage CGImage], rect);
    UIImage* smallImage = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    return smallImage;
}

#pragma mark - Analyze逻辑错误监测
-(NSInteger)LuoJiError
{
    NSInteger i = 4;
    NSInteger index ;
    
    switch (i) {
        case 0:
            index = i;
        case 1:
            index = i * i;
        case 2:
            index = i * i * i;
            break;
            
        default:
            break;
    }
    
    return i + index;
}
@end
