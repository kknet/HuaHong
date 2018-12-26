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
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            @strongify(self);
            [self getDoubanList:^(NSArray<MVVM_Model *> *array) {
                [subscriber sendNext:array];
                [subscriber sendCompleted];
            }];
            return nil;
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
        
        NSMutableArray *array = [NSMutableArray array];
        NSArray *subjects = [data objectForKey:@"subjects"];
        //遍历数组取出 存入数组并回调出去
        [subjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MVVM_Model *model = [MVVM_Model InfoWithDictionary:obj];
//            model.title = @"0";
            [array addObject:model];
        }];
        if (succeedBlock) {
            succeedBlock(array);
        }
        
    } withErrorBlock:^(QKPublicHttpRequestErrorType errorType) {
        
    } isSupportHud:YES isSupportErrorAlert:YES];
    
}

@end
