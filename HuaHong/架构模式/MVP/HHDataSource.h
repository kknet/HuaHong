//
//  HHDataSource.h
//  HuaHong
//
//  Created by qk-huahong on 2019/8/19.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CellConfigureBefore)(id cell, id model, NSIndexPath * indexPath);
typedef void (^selectCell) (NSIndexPath *indexPath);

@interface HHDataSource : NSObject<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)  NSMutableArray *dataArray;;

//自定义
- (id)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before selectBlock:(selectCell)selectBlock;

- (void)addDataArray:(NSArray *)datas;

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
