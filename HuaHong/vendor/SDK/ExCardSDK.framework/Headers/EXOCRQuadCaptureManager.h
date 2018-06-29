//
//  EXOCRQuadCaptureManager.h
//  ExCardSDK
//
//  Created by 肖尧 on 17/4/21.
//  Copyright © 2017年 kubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXOCRQuadCardInfo.h"

/**
 *	@brief 识别回调 EXOCRCompletedCaptureQuadCardBlock, EXOCRCanceledBlock, EXOCRFailedBlock
 *
 *	@discussion 用来设定异步调用的回调
 */
typedef void (^EXOCRCompletedCaptureQuadCardBlock)(int statusCode, EXOCRQuadCardInfo *quadInfo);
typedef void (^EXOCRCanceledBlock)(int statusCode);
typedef void (^EXOCRFailedBlock)(int statusCode, UIImage *recoImg);

typedef enum : NSUInteger {
    EXOCRCaptureCardTypeIDCARD,                 //身份证
    EXOCRCaptureCardTypeVECARD,                 //行驶证
    EXOCRCaptureCardTypeDRCARD,                 //驾驶证
    EXOCRCaptureCardTypeIDCARD_TMP,             //临时身份证
    EXOCRCaptureCardTypeGAJMLWNDTXZ00,          //港澳居民来往内地通行证旧版
    EXOCRCaptureCardTypeGAJMLWNDTXZ13,          //港澳居民来往内地通行证13版
    EXOCRCaptureCardTypeTWJMLWNDTXZ15,          //台湾居民来往内地通行证15版
    EXOCRCaptureCardTypePASSPORT,               //护照
    EXOCRCaptureCardTypeVECARD_2RDPAGE,         //行驶证副页
    EXOCRCaptureCardTypeQYYYZZ3IN1,             //三证合一版本的企业营业执照
    EXOCRCaptureCardTypeHKIDCARD,               //香港身份证
    EXOCRCaptureCardTypeBEIJINGTONG,            //北京通
    EXOCRCaptureCardTypeForeignerIDCard,         //中华人民共和国外国人永久居留身份证
    EXOCRCaptureCardTypeDefault,                //默认取图
} EXOCRCaptureCardType;

@interface EXOCRQuadCaptureManager : NSObject
/**
 获取EXOCRQuadRecoManager实例化对象
 
 @param vc 传入target控制器
 @return EXOCRQuadRecoManager对象
 */
+(instancetype)sharedManager:(UIViewController *)vc;

/**
 调用四边定位服务器识别
 
 @param cardType 要识别卡的类型
 @param completedBlock 识别完成回调，获取处理后的图片
 @param EXOCRCanceledBlock 识别取消回调
 @param EXOCRFailedBlock 识别失败回调
 */
-(void)captureQuadCardWithCardType:(EXOCRCaptureCardType)cardType
                       OnCompleted:(EXOCRCompletedCaptureQuadCardBlock)completedBlock
                        OnCanceled:(EXOCRCanceledBlock)EXOCRCanceledBlock
                          OnFailed:(EXOCRFailedBlock)EXOCRFailedBlock;

/**
 * @brief 扫描页设置，是否显示logo
 * @param bDisplayLogo - 默认为YES
 */
-(void)setDisplayLogo:(BOOL)bDisplayLogo;

/**
 扫描页设置，相册识别是否返回原图
 
 @param bOriginalImage 默认为NO
 */
-(void)setPhotoRecoOriginalImage:(BOOL)bOriginalImage;

/**
 扫描页设置，是否在光线较暗时开启闪光灯（仅在默认扫描视图中有效）
 
 @param bAutoFlash 默认为YES
 */
-(void)setAutoFlash:(BOOL)bAutoFlash;

/**
 设置图像错误提示文字颜色
 
 @param tipColor 文字颜色
 */
-(void)setImageErrorTipColor:(UIColor *)tipColor;

/**
 设置图像错误提示文字字体
 
 @param fontName 字体名称
 @param fontSize 字体大小
 */
-(void)setImageErrorTipFontName:(NSString *)fontName fontSize:(float)fontSize;

/**
 设置服务器版结果view背景颜色
 
 @param bgColor 背景颜色
 */
-(void)setServerResultViewBGColor:(UIColor *)bgColor;

/**
 TabBarController是否交给SDK设置隐藏
 
 @param bControl 是否交给SDK控制（YES:扫描页隐藏TabBarController，退出扫描页时显示;NO:由开发者自行控制TabBarController是否隐藏;默认为YES）
 */
-(void)controlTabBarControllerHiddenBySDK:(BOOL)bControl;

/**
 NavigationrController是否交给SDK设置隐藏
 
 @param bControl 是否交给SDK控制（YES:扫描页隐藏NavigationrController，退出扫描页时显示;NO:由开发者自行控制NavigationrController是否隐藏;默认为YES）
 */
-(void)controlNavigationrControllerHiddenBySDK:(BOOL)bControl;

@end
