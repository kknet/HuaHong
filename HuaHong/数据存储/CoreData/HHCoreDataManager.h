//
//  HHCoreDataManager.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/25.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "City+CoreDataClass.h"
#import "Company+CoreDataClass.h"
#import "Service+CoreDataClass.h"
#import "User+CoreDataClass.h"




@interface HHCoreDataManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,strong,readonly) NSManagedObjectContext *manageContext;

/**
 新增/保存数据
 @param dic 需要添加的数据
 @return 保存成功或失败
 */
- (BOOL)saveData:(NSDictionary *)dic;


/**
 删除数据
 @param predicate 谓词条件
 @return 删除结果
 */
- (BOOL)deleteDataWithCondition:(NSPredicate *)predicate;


/**
 修改数据
 @param userID 查询条件
 @param dic 要更新的新数据
 @return 修改结果
 */
- (BOOL)updateWithUserId:(NSString *)userID Data:(NSDictionary *)dic;

/**
 查询数据
 @param predicate 谓词条件
 @param sortKey 排序关键词
 @param ascending 是否为升序排序
 @return 查询结果
 */
- (NSArray *)queryDataWithCondition:(NSPredicate *)predicate SortKey:(NSString *)sortKey ascending:(BOOL)ascending;
@end
