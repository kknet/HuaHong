//
//  QKProgressHUD.h
//  AFNetworking
//
//  Created by chenhanlin on 2018/1/13.
//

#import <UIKit/UIKit.h>

@interface QKProgressHUD : UIView

@property (nonatomic, strong) NSDictionary *requestInfo;

+ (void)setSuperView:(UIView *)superView;

//显示
+ (void)showWithGif:(NSString *)gif
        requestInfo:(NSDictionary *)info;

+ (void)transferShowError:(NSString *)imagePath
                noticeTxt:(NSString *)noticeTxt
              requestInfo:(NSDictionary *)info
       clickEventCallback:(void(^)(NSInteger index, QKProgressHUD *hud))clickEventCallback;

//隐藏
+ (void)dismiss;

@end
