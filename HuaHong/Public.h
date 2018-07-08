//
//  Public.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/1.
//  Copyright © 2017年 huahong. All rights reserved.
//

#ifndef Public_h
#define Public_h

#define kStory [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]

#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//#define kBaseURL @"http://192.168.0.5"
#define kBaseURL @"http://172.31.0.85"

#import <SVProgressHUD.h>
#import "BaseViewController.h"
#import "UIScrollView+Refresh.h"
#import "HuaHong-Bridging-Header.h"
#import "HuaHong-Swift.h"
#import <SSZipArchive.h>
#import "ReactiveObjc.h"
#import <NSObject+RACKVOWrapper.h>
#import "BaseModel.h"
#import "AppDelegate.h"
#import "HUtils.h"
#import "NSString+Hash.h"

//#import "HHCategory.h"
#import "UIViewExt.h"
#import "UIView+AutoLayout.h"
#import "UILabel+autoReSize.h"
#import "UIColor+Category.h"
#import "NSURL+hook.h"
#import "NSString+IdentityCard.h"
#import "NSArray+NSDictionary_Log.h"
#import "CALayer+borderColor.h"
#import "UIViewController+Alert.h"
#import <Masonry.h>

#import "MapViewController.h"
#import "WaterFallController.h"
#import "LightSinceController.h"
#import "ThreeDTouchController.h"
#import "VoiceController.h"
#import "TakePhotoController.h"
#import "ContactsController.h"
#import "CustomContactsController.h"
#import "RecorderViewController.h"
#import "ImagePickController.h"
#import "MovieFileOutputController.h"
#import "CustomVideoController.h"
#import "AnimationController.h"
#import "MultiRequestController.h"
#import "QRCodeController.h"
#import "CreatQRCodeController.h"
#import "LoadingViewController.h"
#import "AddVideoController.h"
#import "TestViewController.h"
#import "TableViewVC.h"
#import "AnnotationController.h"
#import "SystemNavigationController.h"
#import "BaiDuMapController.h"
#import "DataStorageController.h"
#import "TouchController.h"
#import "ClockViewController.h"
#import "TimerController.h"
#import "TransitionController.h"
#import "DrawingBoardController.h"
#import "ThreadViewController.h"
#import "SessionRequestController.h"
#import "DownLoadViewController.h"
#import "SecurityController.h"
#import "RACViewController.h"
#import "BlockViewController.h"
#import "FunctionViewController.h"
#import "ChainViewController.h"
#import "runtimeViewController.h"
#import "runloopViewController.h"
#import "BlueToothController.h"
#import "CBPeripheralViewController.h"
#import "LeanCloudViewController.h"
#import "FaceViewController.h"
#import "WebViewController.h"
#import "TextViewController.h"
#import "CoreDataController.h"
#import "ViewController.h"
#import "HttpsController.h"
#import "UpLoadViewController.h"
#import "DeleteFileController.h"
#import "XMLController.h"
#import "JSONPlistController.h"
#import "AFController.h"
#import "RegularExpressionController.h"
#import "BridgeController.h"
#import "StrategyController.h"
#import "HHSegmentController.h"
#import "HHFMDBController.h"
#import "HHSwitch.h"
#import "HHLockController.h"
#import "HHPhotoBrowserController.h"
#import "HHCardController.h"
#import "HHMenuController.h"
#import "HHPageControl.h"




#endif /* Public_h */
