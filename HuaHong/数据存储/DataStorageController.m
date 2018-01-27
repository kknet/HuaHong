//
//  DataStorageController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "DataStorageController.h"
#import "DataModel.h"

#define kName @"name"
#define kAge @"age"

@interface DataStorageController ()
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,copy) NSString *filePath2;

@end

@implementation DataStorageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)saveData
{
    DataModel *model = [[DataModel alloc]init];
    model.name = @"huahong";
    model.age = 28;

  /**
     1.偏好设置
   */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:model.name forKey:kName];
    [defaults setInteger:model.age forKey:kAge];
    [defaults synchronize];
    
    
    /**
       2.plist 属性列表
     */
    NSArray *array = @[@"123",@"abc",@"hello world"];
    [array writeToFile:self.filePath atomically:YES];
    
    
    /**
        3.数据归档
     */
    [NSKeyedArchiver archiveRootObject:model toFile:self.filePath2];
    
}
- (IBAction)readData
{
    /**
     1.偏好设置
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:kName];
    NSInteger age = [defaults integerForKey:kAge];
    NSLog(@"name:%@,age:%ld",name,age);

    /**
     2.plist 属性列表
     */
    NSArray *array = [NSArray arrayWithContentsOfFile:self.filePath];
    NSLog(@"array:%@",array);
    
    /**
        3.数据解归档
     */
    DataModel *model2 = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath2];
    NSLog(@"name:%@,age:%ld",model2.name,(long)model2.age);
    
//    NSArray *array1 = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath2];
//    NSLog(@"array1:%@",array1);


    
}

-(NSString *)filePath
{
    if (_filePath == nil) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        _filePath = [docPath stringByAppendingPathComponent:@"huahong.plist"];
    }
    
//    NSLog(@"_filePath:%@",_filePath);
    return _filePath;
}

-(NSString *)filePath2
{
    if (_filePath2 == nil) {
        NSString *docPath = NSTemporaryDirectory();
        _filePath2 = [docPath stringByAppendingPathComponent:@"huahong.data"];
    }
    
//    NSLog(@"_filePath2:%@",_filePath2);
    return _filePath2;
}
@end
