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


/**
 * nil：指向一个对象的空指针,对objective c id 对象赋空值.
 * Nil：指向一个类的空指针,表示对类进行赋空值.
 * NULL：指向其他类型（如：基本类型、C类型）的空指针, 用于对非对象指针赋空值.
 * NSNull：在集合对象中，表示空值的对象.
 */
#import <UIKit/UIKit.h>

@interface HomeVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>

-(void)completationHandler:(void (^)(UIBackgroundFetchResult))completationHandler;


@end
