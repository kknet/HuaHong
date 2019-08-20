//
//  Presenter.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "Presenter.h"

@implementation Presenter

- (instancetype)init{
    if (self = [super init]) {
        [self loadData];
    }
    return self;
}

- (void)loadData{
    
    NSArray *temArray =
    @[
      @{@"name":@"CadsC",@"num":@"9"},
      @{@"name":@"Jadsfes",@"num":@"9"},
      @{@"name":@"Gadsfin",@"num":@"9"},
      @{@"name":@"adci",@"num":@"9"},
      @{@"name":@"adn",@"num":@"9"},
      @{@"name":@"sd",@"num":@"9"},
      @{@"name":@"Jadfes",@"num":@"9"},
      @{@"name":@"adin",@"num":@"9"},
      @{@"name":@"adfci",@"num":@"9"},
      @{@"name":@"CadsC",@"num":@"9"},
      @{@"name":@"Jadsfes",@"num":@"9"},
      @{@"name":@"Gadsfin",@"num":@"9"},
      @{@"name":@"adci",@"num":@"9"},
      @{@"name":@"CadsC",@"num":@"9"},
      @{@"name":@"Jadsfes",@"num":@"9"},
      @{@"name":@"Gadsfin",@"num":@"9"},
      @{@"name":@"adci",@"num":@"9"},
      @{@"name":@"Dsdfn",@"num":@"9"}];
    
    for (int i = 0; i<temArray.count; i++) {
        MVPModel *m = [[MVPModel alloc]initWithDict:temArray[i]];
        [self.dataArray addObject:m];
    }
}



#pragma mark - lazy

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - PresentDelegate
- (void)didClickAddBtnWithNum:(NSString *)num indexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0; i<self.dataArray.count; i++) {
        
        if (i == indexPath.row) {
            MVPModel *m = self.dataArray[indexPath.row];
            m.num    = num;
            break;
        }
    }
    
    
    if ([num intValue] > 6) {
        NSArray *temArray =
        @[
          @{@"name":@"CfC",@"num":@"9"},
          @{@"name":@"sadfa",@"num":@"9"},
          @{@"name":@"sderfx",@"num":@"9"}];
        [self.dataArray removeAllObjects];
        for (int i = 0; i<temArray.count; i++) {
            MVPModel *m = [[MVPModel alloc]initWithDict:temArray[i]];
            [self.dataArray addObject:m];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataForUI)]) {
            [self.delegate reloadDataForUI];
        }
        
    }
}

@end
