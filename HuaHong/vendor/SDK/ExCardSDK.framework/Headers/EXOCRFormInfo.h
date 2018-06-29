//
//  EXOCRFormInfo.h
//  ExCardSDK
//
//  Created by kubo on 16/9/12.
//  Copyright © 2016年 kubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *	@brief 表格识别回调状态码
 *
 *	@discussion 识别回调中获取状态码
 */
#define FORM_CODE_SUCCESS           (0)
#define FORM_CODE_CANCEL            (1)
#define FORM_CODE_RECO_FAIL         (-1)
#define FORM_CODE_FAIL_TIMEOUT      (-2)
#define FORM_CODE_XML_FAIL          (-3)

/**
 *	@brief 表格数据模型类
 */
@interface EXOCRFormInfo : NSObject

@property (nonatomic, strong) NSDictionary *resultDict;    //条目文字
@property (nonatomic, strong) NSDictionary *imageDict;     //条目截图

@end
