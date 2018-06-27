//
//  CoreDataController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/26.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CoreDataController.h"
#import<CoreData/CoreData.h>
#import "HHCoreDataManager.h"
#import"User.h"

@interface CoreDataController ()
@end

@implementation CoreDataController

/**
 * 一、Core Data的操作步骤
 *  1.定义数据模型文件，模型文件是对数据的一种描述
 2.创建沙盒里的数据库文件，数据库文件中的表结构来自模型文件
 *
 * 二、NSManagerObjectContext相当于是个MO (NSMangerObject就是我们使用的model)的容器，可以将MO对象添加到此容器中，也可以修改、删除，调用NSManagerObjectContext的save方法，会将此容器中的对象保存到本地数据库中
 *
 * 三、注意:如果数据模型的文件修改了，则原来的数据库文件得重新创建
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}


#pragma mark - 增
- (IBAction)addUser
{
    static int age = 18;
    if([[HHCoreDataManager sharedManager]saveData:@{@"userID":@"1234",@"age":[NSNumber numberWithInt:age],@"name":@"huahong",@"image":@"01",}]) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
    
    age++;
}

#pragma mark - 删
- (IBAction)removeUser
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = 1234"];
    if ([[HHCoreDataManager sharedManager]deleteDataWithCondition:nil]) {
     
        NSLog(@"删除成功");
    }
    
}

#pragma mark - 改
- (IBAction)upDateUser
{
    if ([[HHCoreDataManager sharedManager]updateWithUserId:@"1234" Data:@{@"userID":@"1124",@"age":@66,@"name":@"huahong",@"image":@"01"}]) {
        
        NSLog(@"修改成功");
    }
}

#pragma mark - 查
- (IBAction)queryUser
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age > %@ && company.name LIKE '机器人'", @"0"];
    NSArray *fetchedObjects = [[HHCoreDataManager sharedManager] queryDataWithCondition:predicate SortKey:@"age" ascending:NO];
    
    for(User *user in fetchedObjects) {
        NSLog(@"id : %@, name : %@, age : %lld,company:%@", user.userID, user.name, user.age,user.company.name);
    }
}


@end
