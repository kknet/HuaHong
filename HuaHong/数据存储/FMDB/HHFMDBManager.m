//
//  HHFMDBManager.m
//  HuaHong
//
//  Created by 华宏 on 2018/5/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHFMDBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface HHFMDBManager ()
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) FMDatabase * db;
@end

@implementation HHFMDBManager

-(instancetype)init
{
    if ([super init]) {
        
        [self createTable];
    }
    return self;
}

#pragma mark - 创建表

-(void)createTable
{
    if ([self.db open]) {
        
        NSString * sql = @"CREATE TABLE 'HHDataTable' ('number' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , name text, age integer, userID text)";
        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"建表失败");
        }
        [self.db close];
        
    } else {
        NSLog(@"打开数据库失败");
    }
    
}

-(void)insertData:(NSArray <DataModel *>*)dataSource
{
    if ([self.db open])
    {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        
        __weak typeof(self) weakSelf = self;
        [queue inDatabase:^(FMDatabase * _Nonnull db) {
            
            for (DataModel *model in dataSource) {
                
              NSString *sql = @"insert into HHDataTable (name, age, userID) values(?, ?, ?)";
                BOOL result = [db executeUpdate:sql,model.name,[NSNumber numberWithInteger:model.age],model.userID];
                if (result) {
                    NSLog(@"插入成功");
                } else {
                    NSLog(@"插入失败");
                }
            }
           
            [weakSelf.db close];
        }];

        
    } else {
        NSLog(@"插入时打开数据库失败");
    }
}

-(void)deleteItem:(NSString *)userID
{
    if ([self.db open])
    {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        
        __weak typeof(self) weakSelf = self;
        [queue inDatabase:^(FMDatabase * _Nonnull db) {
           
//      @"DELETE FROM HHDataTable WHERE userID='%@' AND sacId='%@' AND checkId='%@'"
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM HHDataTable WHERE userID='%@'", userID];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
            
        [weakSelf.db close];
            
        }];

    }else {
        NSLog(@"删除打开失败");
    }
}

-(void)updateItem:(DataModel *)model userID:(NSString *)userID complte:(void (^)(BOOL success))complete
{
    if ([self.db open])
    {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        
        __weak typeof(self) weakSelf = self;
        [queue inDatabase:^(FMDatabase * _Nonnull db) {
          
            NSString *sql = [NSString stringWithFormat:@"update HHDataTable set name = '%@', age = '%@' where userID = '%@'", model.name, [NSNumber numberWithInteger:model.age], userID];
            
            BOOL result = [db executeUpdate:sql];
            if (result) {
                
                NSLog(@"更新成功");
                
            } else {
                NSLog(@"更新失败");
            }
            
            [weakSelf.db close];
            
        }];
        
    }else {
        NSLog(@"更新打开失败");
    }
}

-(NSMutableArray<DataModel *> *)queryData
{
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([self.db open])
    {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];

        __weak typeof(self) weakSelf = self;
        [queue inDatabase:^(FMDatabase * _Nonnull db) {
            
//            NSString *sql = [NSString stringWithFormat:@"select * from HHDataTable where userId= '%@'", userId];
            NSString *sql = [NSString stringWithFormat:@"select * from HHDataTable"];
            FMResultSet *resultSet = [db executeQuery:sql];
            
            while ([resultSet next]) {
                
                DataModel *model = [[DataModel alloc]init];
                model.name = [resultSet stringForColumn:@"name"];
                model.age = [resultSet intForColumn:@"age"];
                model.userID = [resultSet stringForColumn:@"userID"];

                [dataArray addObject:model];
            }

            [weakSelf.db close];
            NSLog(@"查询成功");

            
        }];
        
    }else {
        NSLog(@"查询数据库打开失败");
    }
    
    return dataArray;
}

#pragma mark Getter

-(NSString *)dbPath
{
    if (!_dbPath) {
        
        NSString *docDictionary = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
        _dbPath = [docDictionary stringByAppendingString:@"Site.db"];
        
        NSLog(@"DBPath == %@",_dbPath);
    }
    return _dbPath;
}

-(FMDatabase *)db
{
    if (!_db) {
        _db = [FMDatabase databaseWithPath:self.dbPath];
        
    }
    return _db;
}
@end
