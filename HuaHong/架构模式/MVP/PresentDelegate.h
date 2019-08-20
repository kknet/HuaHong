//
//  PresentDelegate.h
//  HuaHong
//
//  Created by qk-huahong on 2019/8/19.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PresentDelegate <NSObject>

@optional
// 刷新UI
- (void)reloadDataForUI;

// UI ---> model
- (void)didClickAddBtnWithNum:(NSString *)num indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
