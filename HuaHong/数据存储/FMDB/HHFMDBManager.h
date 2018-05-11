//
//  HHFMDBManager.h
//  HuaHong
//
//  Created by 华宏 on 2018/5/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface HHFMDBManager : NSObject

-(void)insertData:(NSArray <DataModel *>*)dataSource;

-(void)deleteItem:(NSString *)userID;

-(void)updateItem:(DataModel *)model userID:(NSString *)userID complte:(void (^)(BOOL success))complete;

-(NSMutableArray<DataModel *> *)queryData;


@end
