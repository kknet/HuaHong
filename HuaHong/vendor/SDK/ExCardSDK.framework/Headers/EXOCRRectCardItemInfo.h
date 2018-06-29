//
//  EXOCRRectCardItemInfo.h
//  ExCardSDK
//
//  Created by kubo on 16/9/6.
//  Copyright © 2016年 kubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *	@brief 四边定位卡证条目数据模型类
 */
@interface EXOCRRectCardItemInfo : NSObject

@property (assign, nonatomic) int ItemID;
@property (strong, nonatomic) NSString *KeyWord;
@property (strong, nonatomic) NSString *OCRText;
@property (strong, nonatomic) NSString *rect;

@end
