//
//  CoreDataController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/26.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CoreDataController.h"
#import<CoreData/CoreData.h>
#import"User.h"

@interface CoreDataController ()
@property (nonatomic,strong) NSManagedObjectContext *moContext; //对数据进行操作
@end

@implementation CoreDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self openDB];
    
    // 1.添加
    [self addUser];
    
    // 2.查询
//    [self queryUser];

    // 3.修改
//    [self upDateUser];
    
    // 4.删除
//    [self removeUser];
}

/**
 * 一、Core Data的操作步骤
 *  1.定义数据模型文件，模型文件是对数据的一种描述
 2.创建沙盒里的数据库文件，数据库文件中的表结构来自模型文件
 *
 * 二、NSManagerObjectContext相当于是个MO (NSMangerObject就是我们使用的model)的容器，可以将MO对象添加到此容器中，也可以修改、删除，调用NSManagerObjectContext的save方法，会将此容器中的对象保存到本地数据库中
 *
 * 三、
 *   注意:如果数据模型的文件修改了，则原来的数据库文件得重新创建
 */

- (void)removeUser
{
    // 1.将需要删除的MO查询出来
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    //定义条件，查询需要删除的用户
    request.predicate = [NSPredicate predicateWithFormat:@"userID = '1003'"];
    
    NSArray *result = [_moContext executeFetchRequest:request error:nil];
    
    // 2.删除
    for(User *user in result) {
        //将MO对象user从context中删除
        [_moContext deleteObject:user];
    }
    
    // 3.保存
    [_moContext save:nil];
}

- (void)upDateUser
{
    // 1.将需要修改的MO查询出来
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    //定义条件，查询需要修改的用户
    request.predicate = [NSPredicate predicateWithFormat:@"userID = '1003'"];
    
    NSArray *result = [_moContext executeFetchRequest:request error:nil];
    
    // 2.修改
    for(User *user in result) {
        user.name =@"张三";
        user.age =@35;
    }
    
    // 3.保存
    [_moContext save:nil];
}


- (void)queryUser
{
    
    NSFetchRequest *requset = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    // 2.定义查询的条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age > 20 && name LIKE 'D*'"];
    requset.predicate = predicate;
    
    // 3.context执行查询操作
    NSArray *array = [_moContext executeFetchRequest:requset error:nil];
    
    for(User *user in array) {
        NSLog(@"id : %@, name : %@, age : %@", user.userID, user.name, user.age);
    }
}

- (void)addUser
{
    // NSManagerObject MO对象不能使用以下方式创建
    //    User *user = [[User alloc] init];
    //    user.userID = @"1001";
    
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"inManagedObjectContext:_moContext];
    user.userID =@"1003";
    user.age =@22;
    user.name =@"Dave";
    //将image转化对应的格式的二进制数据
    user.image = UIImageJPEGRepresentation([UIImage imageNamed:@"01"],1);
    //向context容器中添加mo对象
    [_moContext insertObject:user];
    
    if([_moContext save:nil]) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
}

//查询数据
- (void)openDB
{
    // 1.加载数据模型文件
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model"withExtension:@"momd"];
    // NSManagedObjectModel用于加载数据模型文件
    NSManagedObjectModel *dataModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    // 2.打开数据库
    // NSPersistentStoreCoordinator用于管理本地的数据库文件
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:dataModel];
    
    //定义数据库文件的沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/Model.sqlite"];
    
    NSLog(@"filePath : %@", filePath);
    
    NSURL*dbURL = [NSURL fileURLWithPath:filePath];
    
    NSError*error=nil;
    //打开数据文件
    /**
     *  1.如果文件不存在，则新创建数据库文件
     *  2.如果文件存在，则直接打开
     *  storeType :存储格式，NSSQLiteStoreType SQLite数据库文件
     */
    [store addPersistentStoreWithType:NSSQLiteStoreType
                       configuration:nil
                                 URL:dbURL
                             options:nil
                               error:&error];
    if(error) {
        NSLog(@"打开数据库出错: %@", error);
    }else{
        NSLog(@"打开数据库成功");
    }
    
    
    _moContext= [[NSManagedObjectContext alloc]init];
    _moContext.persistentStoreCoordinator= store;
}

@end
