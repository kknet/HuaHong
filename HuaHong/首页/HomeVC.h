//
//  HomeVC.h
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

/**
 * Cmd+Shift+o         快速查找类
 * Ctrl+6              列出当前文件所有方法
 * Ctrl+Cmd+up         切换.h和.m
 * Cmd+Shift+Y         显示/隐藏控制台
 * Cmd+Ctrl+Left/Right 到上/下一次编辑的位置
 * Cmd+T               新建tab栏
 * Cmd+Shift+[         切换tab栏
 * ESC                 代码补全
 */
#import <UIKit/UIKit.h>

@interface HomeVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>

-(void)completationHandler:(void (^)(UIBackgroundFetchResult))completationHandler;
@end
