//
//  MVVM_ViewModel.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVVM_ViewModel.h"
#import "MVVM_Model.h"
#import "MVVM_Cell.h"
@implementation MVVM_ViewModel

-(NSMutableArray *)InfoArray
{
    if (_InfoArray == nil) {
        _InfoArray = [NSMutableArray array];
    }
    return  _InfoArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self getInfo];
    }
    return self;
}

- (void)getInfo
{
    //实际开发是通过网络请求获取数据，在此模拟给出一个数据
    NSArray *array = @[@[@{@"image" : @"search_expert", @"title" : @"标题1", @"subTitle" : @"副标题1"},
                         @{@"image" : @"search_expert", @"title" : @"标题2", @"subTitle" : @"副标题2"}],
                       @[@{@"image" : @"search_expert", @"title" : @"标题3", @"subTitle" : @"副标题3"},
                         @{@"image" : @"search_expert", @"title" : @"标题4", @"subTitle" : @"副标题4"},
                         @{@"image" : @"search_expert", @"title" : @"标题5", @"subTitle" : @"副标题5"},
                         @{@"image" : @"search_expert", @"title" : @"标题6", @"subTitle" : @"副标题6"},
                         @{@"image" : @"search_expert", @"title" : @"标题7", @"subTitle" : @"副标题7"}]];
    //解析数据，转模型保存
    for (int i = 0; i < array.count ; i++) {
        NSMutableArray * tempArray = [NSMutableArray array];
        for (NSDictionary * dict in array[i]) {
            [tempArray addObject:[MVVM_Model InfoWithDictionary:dict]];
        }
        [self.InfoArray addObject:tempArray];
    }
}

#pragma mark -- 重新自定义一套UITableView的代理方法
- (NSInteger)numberOfSections
{
    return self.InfoArray.count;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.InfoArray[section] count];
}

- (MVVM_Cell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVVM_Cell *cell = [MVVM_Cell cellWithTableView:tableView];
    cell.model = self.InfoArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取到当前被点击的cell
    MVVM_Cell *cell = (MVVM_Cell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *str = [NSString stringWithFormat:@"点击了第%ld组第%ld行", indexPath.section, indexPath.row];
    cell.label.text = str;
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"第一组";
    }
    return @"第二组";
}

- (NSString *)titleForFooterInSection:(NSInteger)section
{
    return @"这是尾部标题";
}

@end
