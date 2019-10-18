//
//  MultiRequestController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/27.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "MultiRequestController.h"

@interface MultiRequestController ()

@end

@implementation MultiRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多网络请求";
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self barrierRequest];
}

//MARK: - 无序请求，全部完成再执行下一步
//支持单例模式
- (void)request1
{
   
    
    dispatch_group_t downLoadGroup = dispatch_group_create();
    
    for (int i=0; i<10; i++) {
        
        dispatch_group_enter(downLoadGroup);
                  
        
//        [self sessionRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//                 NSLog(@"%d---%d",i,i);
//                dispatch_group_leave(downLoadGroup);
//        }];
        
         [[HHRequestManager defaultManager]requestByUrl:@"http://58.215.175.244:8090/thirdprovider/datacenter/area/findAllAreaJsonTree" params:@{} requestType:POST
               success:^(id  _Nonnull responseObject) {

                NSLog(@"%d---%d",i,i);
              dispatch_group_leave(downLoadGroup);

               } failure:^(RequestErrorType error) {

                   NSLog(@"%d---%d",i,i);
                   dispatch_group_leave(downLoadGroup);

               } isSupportHud:YES isSupportErrorAlert:YES];
    }
    
    
    dispatch_group_notify(downLoadGroup, dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
}

//无序请求，全部完成再执行下一步
//单例模式无效
- (void)request2
{
    
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
   __block NSInteger count = 0;
    for (int i=0; i<10; i++) {
        
        
        [self sessionRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
             NSLog(@"%d---%d",i,i);
              count++;
              if (count ==10) {
                  dispatch_semaphore_signal(sema);
                  count = 0;
              }
        }];
       
        
    }
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
    
}


//MARK: - 按顺序请求，全部完成再执行下一步
//单例模式无效
- (void)request3
{
   
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    for (int i=0; i<10; i++) {
        
        [self sessionRequest:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
             NSLog(@"%d---%d",i,i);
            dispatch_semaphore_signal(sema);
            
        }];
        
//         [[HHRequestManager defaultManager]requestByUrl:@"http://58.215.175.244:8090/thirdprovider/datacenter/area/findAllAreaJsonTree" params:@{} requestType:POST
//               success:^(id  _Nonnull responseObject) {
//
//                NSLog(@"%d---%d",i,i);
//              dispatch_semaphore_signal(sema);
//
//               } failure:^(RequestErrorType error) {
//
//                   NSLog(@"%d---%d",i,i);
//                    dispatch_semaphore_signal(sema);
//
//               } isSupportHud:YES isSupportErrorAlert:YES];
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
    
    
    
}

- (void)barrierRequest
{
    dispatch_queue_t queue = dispatch_queue_create("hh", DISPATCH_QUEUE_CONCURRENT);
       dispatch_async(queue, ^{
           
           NSLog(@"----1-----");
           [self requestData];
       });
    
//    dispatch_barrier_async(queue, ^{
//          });
    
       dispatch_async(queue, ^{
           NSLog(@"----2-----");
           [self requestData];
       });
       
//       dispatch_barrier_async(queue, ^{
//       });
       
       dispatch_async(queue, ^{
          
           NSLog(@"----3-----");
           [self requestData];
       });
    
    dispatch_barrier_async(queue, ^{
          });
       dispatch_async(queue, ^{
           NSLog(@"----4-----");
           [self requestData];
       });
    
//    dispatch_barrier_async(queue, ^{
//          });
       dispatch_async(queue, ^{
           NSLog(@"----5-----");
           [self requestData];
       });
    
//    dispatch_barrier_async(queue, ^{
//          });
       dispatch_async(queue, ^{
           NSLog(@"----6-----");
           [self requestData];
       });
    
    dispatch_barrier_async(queue, ^{
          });
       dispatch_async(queue, ^{
           NSLog(@"----7-----");
           [self requestData];
       });
    
//    dispatch_barrier_async(queue, ^{
//          });
       dispatch_async(queue, ^{
           NSLog(@"----8-----");
           [self requestData];
       });
    
//    dispatch_barrier_async(queue, ^{
//          });
    
       dispatch_async(queue, ^{
           NSLog(@"----9-----");
           [self requestData];
       });
    
//    dispatch_barrier_async(queue, ^{
//
//    });
    
       dispatch_async(queue, ^{
           NSLog(@"----10-----");
           [self requestData];
           
          
       });
    
    dispatch_barrier_async(queue, ^{
           
       });
    
    dispatch_async(queue, ^{
        
             dispatch_async(dispatch_get_main_queue(), ^{
                    
                 NSLog(@"----end-----");

                 });
              
             
          });
   
   
}
- (void)requestData
{
    [[HHRequestManager defaultManager]requestByUrl:@"http://58.215.175.244:8090/thirdprovider/datacenter/area/findAllAreaJsonTree" params:@{} requestType:POST
       success:^(id  _Nonnull responseObject) {
//           [MBProgressHUD showMessage:@"请求成功"];

       } failure:^(RequestErrorType error) {
           [MBProgressHUD showMessage:@"请求失败"];

       } isSupportHud:YES isSupportErrorAlert:YES];
}

- (void)sessionRequest:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        completionHandler(data,response,error);

           }]resume] ;
    
}
@end
