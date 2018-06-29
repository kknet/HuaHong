//
//  EXOCRFormRecoManager.h
//  ExCardSDK
//
//  Created by kubo on 16/9/12.
//  Copyright © 2016年 kubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EXOCRFormInfo.h"

/**
 *	@brief 表格识别回调EXOCRCompletedFormBlock, EXOCRCanceledBlock, EXOCRFailedBlock
 *
 *	@discussion 用来设定异步调用的回调
 */
typedef void (^EXOCRCompletedFormBlock)(int statusCode, EXOCRFormInfo *formInfo);
typedef void (^EXOCRCanceledBlock)(int statusCode);
typedef void (^EXOCRFailedBlock)(int statusCode, UIImage *recoImg);

@interface EXOCRFormRecoManager : NSObject
/**
 *	@brief 获取EXOCRFormRecoManager实例化对象
 *  @return EXOCRFormRecoManager对象
 */
+(instancetype)sharedManager:(UIViewController *)vc;

/**
 * @brief 调用表格扫描识别
 * @param xmlFilePath - 表格配置xml文件路径
 * @param completedBlock - 识别完成回调，获取识别结果EXOCRFormInfo对象
 * @param EXOCRCanceledBlock - 识别取消回调
 * @param EXOCRFailedBlock - 识别失败回调
 */
-(void)recoFormFromStreamWithXML:(NSString *)xmlFilePath
                     OnCompleted:(EXOCRCompletedFormBlock)completedBlock
                      OnCanceled:(EXOCRCanceledBlock)EXOCRCanceledBlock
                        OnFailed:(EXOCRFailedBlock)EXOCRFailedBlock;

/**
 * @brief 设置扫描超时时间，默认扫描视图在failblock中回调，自定义扫描视图在代理方法recoTimeout中回调（自定义扫描视图建议自行添加超时逻辑，不使用该接口）
 * @param timeout - 超时时间（默认为0，无超时）
 */
-(void)setRecoTimeout:(NSTimeInterval)timeout;

/**
 * @brief 扫描页面调用方式设置，设置扫描页面调用方式
 * @param bByPresent - 是否以present方式调用，默认为NO，YES-以present方式调用，NO-以sdk默认方式调用(push或present)
 */
-(void)displayScanViewControllerByPresent:(BOOL)bByPresent;

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

/**
 * @brief 扫描页设置，是否手动提交识别结果
 * @param bManualCommit - 默认为YES；若设置为NO，隐藏扫描页结果列表及提交按钮，仅返回第一个条目的识别结果
 */
-(void)setManualCommit:(BOOL)bManualCommit;

/**
 扫描页设置，是否在光线较暗时开启闪光灯（仅在默认扫描视图中有效）
 
 @param bAutoFlash 默认为YES
 */
-(void)setAutoFlash:(BOOL)bAutoFlash;

/**
 * @brief 扫描页设置，是否显示logo
 * @param bDisplayLogo - 默认为YES
 */
-(void)setDisplayLogo:(BOOL)bDisplayLogo;

/**
 * @brief 扫描页设置，扫描框颜色
 * @param rgbColor - rgb颜色值(例:0xffffff)
 * @param alpha - 透明度(例：0.8f, 0-1之间)
 */
-(void)setScanFrameColorRGB:(long)rgbColor andAlpha:(float)alpha;

/**
 * @brief 扫描页设置，扫描字体颜色
 * @param rgbColor - rgb颜色值(例:0xffffff)
 */
-(void)setScanTextColorRGB:(long)rgbColor;

/**
 * @brief 扫描页设置，扫描提示主标题字体名称及字体大小
 * @param fontName - 字体名称
 * @param fontSize - 字体大小
 */
-(void)setScanTitleFontName:(NSString *)fontName andFontSize:(float)fontSize;

/**
 * @brief 扫描页设置，扫描提示副标题字体名称及字体大小
 * @param fontName - 字体名称
 * @param fontSize - 字体大小
 */
-(void)setScanSubtitleFontName:(NSString *)fontName andFontSize:(float)fontSize;

/**
 * @brief 扫描页设置，列表背景颜色
 * @param rgbColor - rgb颜色值(例:0xffffff)
 * @param alpha - 透明度(例：0.8f, 0-1之间)
 */
-(void)setFormBackgroundColorRGB:(long)rgbColor andAlpha:(float)alpha;

/**
 * @brief 扫描页设置，列表分隔线颜色
 * @param rgbColor - rgb颜色值(例:0xffffff)
 * @param alpha - 透明度(例：0.8f, 0-1之间)
 */
-(void)setFormSeparatprColorRGB:(long)rgbColor andAlpha:(float)alpha;

/**
 * @brief 扫描页设置，列表条目文字颜色（正常状态）
 * @param rgbColor - rgb颜色值(例:0xffffff)
 */
-(void)setItemNormalTextColorRGB:(long)rgbColor;

/**
 * @brief 扫描页设置，列表条目文字颜色（选中状态）
 * @param rgbColor - rgb颜色值(例:0xffffff)
 */
-(void)setItemSelectedTextColorRGB:(long)rgbColor;
@end
