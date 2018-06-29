//
//  RectCardInfo.h
//  ExCardSDK
//
//  Created by kubo on 16/9/6.
//  Copyright © 2016年 kubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EXOCRRectCardItemInfo.h"

/**
 *	@brief 四边定位卡证识别回调状态码
 *
 *	@discussion 识别回调中获取状态码
 */
#define RECT_CODE_SUCCESS       (0)
#define RECT_CODE_CANCEL        (1)
#define RECT_CODE_RECO_FAIL     (-1)
#define RECT_CODE_FAIL_TIMEOUT    (-2)
#define RECT_CODE_XML_FAIL      (-3)

/**
 *	@brief 四边定位卡证数据模型类
 */
@interface EXOCRRectCardInfo : NSObject

@property (strong, nonatomic) NSString *cardType;           //卡证类型
@property (assign, nonatomic) int pageType;                 //1为正面，2为反面
@property (strong, nonatomic) NSMutableArray *itemArray;    //识别数据(EXOCRRectCardItemInfo数组)
@property (strong, nonatomic) UIImage *cardImg;             //卡证截图

- (NSString *)toString;
@end
