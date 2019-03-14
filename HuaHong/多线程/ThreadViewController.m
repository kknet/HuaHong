//
//  ThreadViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/7.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "ThreadViewController.h"
#import "HHVideoManager.h"
#define imageStr @"http://img31.mtime.cn/pi/2013/03/08/144644.81111130_1280X720.jpg"
@interface ThreadViewController ()
@property (nonatomic,strong) NSOperationQueue *queue;
@end

@implementation ThreadViewController

/**
 * atomic原子属性是线程安全的，安全的前提是：读写不同时操作
 * 只能在set/get操作才能保证线程安全，且耗性能
 -- 开不开线程，取决于执行任务的函数，同步不开，异步就开
 -- 开几条线程，取决于队列，串行开一条，并发开多条（异步）
 */
- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //      [self threadDemo];
    //
    //      [self gcdLoadImage];
    //
    //      [self gcddemo];
    
    //          [self barrier];
    //
    //      [self once];
    
              [self group];
    
    //    [self operation];
    
//    [self apply];
    
//    [self semaphore];
    
}

-(NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
    }
    
    return _queue;
}

#pragma mark NSThread
- (void) threadDemo
{
    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(threadAction) object:nil];
    [thread1 start];
    
    [NSThread detachNewThreadSelector:@selector(threadAction) toTarget:self withObject:nil];
    
    [self performSelectorInBackground:@selector(threadAction) withObject:nil];
}


#pragma mark GCD
-(void)gcdLoadImage
{
    //串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("name", DISPATCH_QUEUE_SERIAL);
    
    //并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("name", DISPATCH_QUEUE_CONCURRENT);
    
    // 1> 获取全局队列（并行队列）0:QOS_CLASS_DEFAULT
//    *  - QOS_CLASS_USER_INTERACTIVE
//    *  - QOS_CLASS_USER_INITIATED
//    *  - QOS_CLASS_DEFAULT
//    *  - QOS_CLASS_UTILITY
//    *  - QOS_CLASS_BACKGROUND
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    
    // 2> 在全局队列上异步执行
    dispatch_async(queue, ^{
      
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
        
        // 3>回到主线程刷新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setImage:image];
        });
    });
}

-(void)gcddemo
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"aaaa");
        });
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"bbbb");

        });
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"cccc");

        });
    });
}

#pragma mark GCD Barrier阻塞
-(void)barrier
{
    //只能用并发队列(全局队列也不可以)，要放在同一个队列
    dispatch_queue_t queue = dispatch_queue_create("hh", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"----1-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----2-----%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"----3-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----4-----%@", [NSThread currentThread]);
    });
    
}

#pragma mark GCD 一次性执行
-(void)once
{
    
        static dispatch_once_t onceToken;
//        NSLog(@"%zd",onceToken);
        dispatch_once(&onceToken, ^{
            NSLog(@"hello %@",[NSThread currentThread]);
        });
        
//        NSLog(@"%zd",onceToken);
    
}

#pragma mark 单例
+(instancetype)sharedManager
{
    //推荐
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HHVideoManager alloc]init];
    });

    return instance;
    
    //方式二
//    static id instance = nil;
//    @synchronized(self){
//        if (instance == nil) {
//            instance = [[VideoManager alloc]init];
//        }
//    }
//
//    return instance;
    
}

#pragma mark 调度组
//并行执行，notify最后执行
-(void)group
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"aaaa");
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1.0];
        sleep(1);
        NSLog(@"bbbb");
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"cccc");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"over");
    });
}

//调度组原理
-(void)group1
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("hh", DISPATCH_QUEUE_CONCURRENT);
    
    //任务1
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务1");
        dispatch_group_leave(group);
    });
    
    //任务2
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务2");
        dispatch_group_leave(group);
    });
    
    //任务3
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务3");
        dispatch_group_leave(group);
    });
    
    //等待组中任务都执行完毕，再执行代码块中的代码
    dispatch_group_notify(group, queue, ^{
        NSLog(@"over");
    });
    
    //等待组中任务都执行完毕，再执行后续代码
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    [NSThread sleepForTimeInterval:1.0];

    NSLog(@"wait");
    
    
}

#pragma mark NSOperation
-(void)operation
{
    //方式1
//    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(threadAction) object:nil];
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [queue addOperation:op];
    
    //方式2
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"OperationQueue :%@",[NSThread currentThread]);
    }];
    
    //使用服务质量，等价于优先级，优先级已不常用（优先级高的执行机率高，并不能保证先全部执行完）
//    op.queuePriority = NSOperationQueuePriorityVeryHigh;
    op.qualityOfService = NSQualityOfServiceUserInteractive;
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"op1 :%@",[NSThread currentThread]);
    }];
//    op.queuePriority = NSOperationQueuePriorityNormal;
    op1.qualityOfService = NSQualityOfServiceBackground;

    
    //最大并发数
    self.queue.maxConcurrentOperationCount = 5;
    
    //完成回调
    [op setCompletionBlock:^{
        NSLog(@"end :%@",[NSThread currentThread]);
        
        //子线程回到主线程
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
        }];
        
    }];
    
    //取消单个操作
    [op cancel];
    //取消全部操作(正在执行的操作会执行完毕)
    [self.queue cancelAllOperations];
    
    //暂停(正在执行的操作会执行完毕)
    self.queue.suspended = YES;
    //继续
    [self.queue setSuspended:NO];
    
    //添加依赖，可跨队列 注意避免循环依赖
    [op1 addDependency:op];
    
    //添加到队列
    [self.queue addOperations:@[op,op1] waitUntilFinished:NO];;
//    [self.queue addOperation:op1];

    
    //方式3
////    _queue = [[NSOperationQueue alloc]init];
//    [self.queue addOperationWithBlock:^{
//        NSLog(@"OperationQueue :%@",[NSThread currentThread]);
//    }];
}
- (void) threadAction
{
    //互斥锁
    @synchronized(self){
        
        //这种方式加载图片要放在主线程，cell里面图片加载不出来可以用占位图
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
                          
//        [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];

        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//            [NSOperationQueue currentQueue]
            [self setImage:image];
        }];
    }
}


-(void)setImage:(UIImage *)image
{
    self.view.layer.contents = (__bridge id)(image.CGImage);

}

#pragma mark - GCD替代for循环
- (void)apply
{
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    
//    dispatch_apply(10, queue, ^(size_t index) {
//        NSLog(@"%zu",index);
//    });
    
    for (int i=0; i<10; i++) {
        NSLog(@"%d",i);
    }
}

- (void)semaphore
{
    dispatch_semaphore_t sem = dispatch_semaphore_create(1);//线程数
    
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        NSLog(@"%zd",index);
        
        sleep(2);
        
        NSLog(@"over %zd",index);

        dispatch_semaphore_signal(sem);
        
        
    });
    
    
}

- (void)lock
{
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        
        NSLock *lock = [[NSLock alloc]init];
        [lock lock];
        
        NSLog(@"%zd",index);
        sleep(2);
        NSLog(@"over %zd",index);
        
        [lock unlock];
    });
}
@end
