//
//  MVVM_ViewModel.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVM_ViewModel.h"
#import "MVVM_Model.h"

#define url @"https://api.douban.com/v2/movie/in_theaters?apikey=0b2bdeda43b5688921839c8ecb20399b&city=%E5%8C%97%E4%BA%AC&start=0&count=100&client=&udid="

@interface MVVM_ViewModel ()
@property (nonatomic,strong)RACCommand *command;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation MVVM_ViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initViewModel];
    }
    return self;
}


/** 初始化命令 */
- (void)initViewModel
{
    @weakify(self);
    
    self.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSLog(@"input:%@",input);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [self getDoubanList:^(NSArray<MVVM_Model *> *array) {
                self.dataArray = array.mutableCopy;
                [subscriber sendNext:array];
                [subscriber sendCompleted];
            }];
            
            return [RACDisposable disposableWithBlock:^{ }];
        }];
        
        
        /**
         * value = [subscriber sendNext:array]的array
         * 也可以直接 return signal;
         **/
        return [signal map:^id _Nullable(id  _Nullable value) {
            
//            NSLog(@"value:%@",value);
            return value;
        }];
    }];
    
}


/** 网络请求 */
- (void)getDoubanList:(void(^)(NSArray<MVVM_Model*> *array))succeedBlock {
    
    [[QKHttpRequestManager defaultManager]requestDataByUrl:^NSString *{
        return url;
    } withParams:^id{
        return @{};
    } withHttpType:^QKPublicHttpType{
        return QKPublicGET;
    } withProgress:^(id progress) {
        
    } withResultBlock:^(NSDictionary *data) {
        
         NSArray *subjects = [data objectForKey:@"subjects"];
        
        NSArray *array = [[subjects.rac_sequence map:^id _Nullable(id  _Nullable value) {
            
            return [MVVM_Model parserModelWithDictionary:value];
        }]array];
        
        if (succeedBlock) {
            succeedBlock(array);
        }
        
    } withErrorBlock:^(QKPublicHttpRequestErrorType errorType) {
        
    } isSupportHud:YES isSupportErrorAlert:YES];
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}
//- (void)clicked:(NSIndexPath *)indexPath
//{
//    MVVM_Model *model = self.dataArray[indexPath.item];
//    model.number++;
//    [self.dataArray removeObject:model];
//    
//}
@end
