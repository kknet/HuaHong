//
//  HHCoreDataManager.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/25.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHCoreDataManager.h"

#define EntityName @"User"
@interface HHCoreDataManager()
@property (nonatomic,strong) NSManagedObjectContext *manageContext;

@end
@implementation HHCoreDataManager

+ (instancetype)sharedManager
{
    static HHCoreDataManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [HHCoreDataManager new];
    });
    
    return _manager;
}

- (NSManagedObjectContext *)manageContext
{
    if (!_manageContext)
    {
        self.manageContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        //模型文件的url
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"Model" withExtension:@"momd"];
        
        //根据url，获取模型文件
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:url];
        
        //设置模型文件 持久性存储协调器
        NSPersistentStoreCoordinator *per = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        
        //定义数据库文件的沙盒目录
        NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/Model.sqlite"];
        NSURL*dbURL = [NSURL fileURLWithPath:filePath];
        
        //添加数据库文件路径
        NSError*error=nil;
        [per addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:nil error:&error];
        
        [_manageContext setPersistentStoreCoordinator:per];
        
    }
    
    return _manageContext;
}

#pragma mark - 新增/保存数据
- (BOOL)saveData:(NSDictionary *)dic
{
    User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:[HHCoreDataManager sharedManager].manageContext];
    
    user.userID = [dic objectForKey:@"userID"];
    user.age = [dic objectForKey:@"age"];
    user.name = [dic objectForKey:@"name"];
    NSString *imageName = [dic objectForKey:@"image"];
    UIImage *image = [UIImage imageNamed:imageName];
    user.image = UIImageJPEGRepresentation(image,1);
    
    //向context容器中添加mo对象
    //    [[HHCoreDataManager sharedManager].manageContext insertObject:user];
    
    return [[HHCoreDataManager sharedManager].manageContext save:nil];
}

#pragma mark - 删除数据
- (BOOL)deleteDataWithCondition:(NSPredicate *)predicate
{
    // 1.将需要删除的MO查询出来
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:EntityName inManagedObjectContext:[HHCoreDataManager sharedManager].manageContext];
    [fetchRequest setEntity:entity];
    
    // 谓词条件
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@", @"1003"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[HHCoreDataManager sharedManager].manageContext executeFetchRequest:fetchRequest error:&error];
    
    //遍历删除
    for (User *user in fetchedObjects) {
        [[HHCoreDataManager sharedManager].manageContext deleteObject:user];
    }
    
    return [[HHCoreDataManager sharedManager].manageContext save:nil];
    
    
    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:EntityName inManagedObjectContext:[HHCoreDataManager sharedManager].manageContext];
    [fetchRequest1 setEntity:entity1];
    
    // 谓词条件
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@", @"1003"];
    [fetchRequest1 setPredicate:predicate];
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc]initWithFetchRequest:fetchRequest1];
    deleteRequest.resultType = NSBatchDeleteResultTypeObjectIDs;
    NSBatchDeleteResult *deleteresult = [self.manageContext executeRequest:deleteRequest error:nil];
    NSArray *resultArr = deleteresult.result;
    NSDictionary *dic = @{NSDeletedObjectsKey:resultArr};
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:dic intoContexts:@[self.manageContext]];
    
}

#pragma mark - 修改数据
- (BOOL)updateWithUserId:(NSString *)userID Data:(NSDictionary *)dic
{
    //1.将需要修改的数据查询出来
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:EntityName inManagedObjectContext:[HHCoreDataManager sharedManager].manageContext];
    [fetchRequest setEntity:entity];
    
    // 谓词条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@", userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[HHCoreDataManager sharedManager].manageContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        return NO;
    }
    
    for (User *user in fetchedObjects)
    {
        user.userID = [dic objectForKey:@"userID"];
        user.name = [dic objectForKey:@"name"];
        user.age = [dic objectForKey:@"age"];
    }
    
    return [[HHCoreDataManager sharedManager].manageContext save:nil];
    
    /** 不加载到内存，直接对数据库更新，然后告诉context更新了什么 */
    NSBatchUpdateRequest *updateRequest = [[NSBatchUpdateRequest alloc]initWithEntityName:EntityName];
    //指定更新条件
    updateRequest.predicate = [NSPredicate predicateWithFormat:@"age = %@",@(20)];
    //更新的数据
    updateRequest.propertiesToUpdate = @{@"name":@"hello"};
    updateRequest.resultType = NSUpdatedObjectIDsResultType;
    NSBatchUpdateResult *result = [self.manageContext executeRequest:updateRequest error:nil];
    NSArray *upDataIDs = result.result;
    //merge change
    NSDictionary *updataDic = @{NSUpdatedObjectsKey:upDataIDs};
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:updataDic intoContexts:@[self.manageContext]];
}
#pragma mark - 查询数据
- (NSArray <User *> *)queryDataWithCondition:(NSPredicate *)predicate SortKey:(NSString *)sortKey ascending:(BOOL)ascending
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:EntityName inManagedObjectContext:[HHCoreDataManager sharedManager].manageContext];
    [fetchRequest setEntity:entity];
    
    //  谓词
    //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@", @"1003"];
    [fetchRequest setPredicate:predicate];
    
    //排序
    if (sortKey && sortKey.length)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    }
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[HHCoreDataManager sharedManager].manageContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        return @[];
    }
    
    return fetchedObjects;
}
@end
