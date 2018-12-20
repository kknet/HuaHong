//
//  QKProgressHUD.m
//  AFNetworking
//
//  Created by chenhanlin on 2018/1/13.
//

#import "QKProgressHUD.h"
#import "UIImage+GIF.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface QKProgressHUD()

@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) FLAnimatedImageView *gifImageView;
@property (nonatomic, strong) NSNumber *isLoading;

@property (nonatomic, strong) FLAnimatedImageView *errorImageView;
@property (nonatomic, strong) UILabel *errorMsgLabel;
@property (nonatomic, strong) UIButton *errorRetryBtn;
@property (nonatomic, strong) void(^clickEventCallback)(NSInteger index, QKProgressHUD *hud);
@end

@implementation QKProgressHUD

+ (QKProgressHUD*)sharedView {
    static dispatch_once_t once;
    static QKProgressHUD *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] init];
    });
    return sharedView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.gifImageView =({
            self.gifImageView = [[FLAnimatedImageView alloc] initWithFrame:self.bounds];
            self.gifImageView;
        });
        [self addSubview:self.gifImageView];
        
        self.errorImageView = ({
            self.errorImageView = [FLAnimatedImageView new];
            self.errorImageView;
        });
        [self addSubview:self.errorImageView];
        
        self.errorMsgLabel = ({
            self.errorMsgLabel = [UILabel new];
            self.errorMsgLabel.textAlignment = NSTextAlignmentCenter;
            self.errorMsgLabel;
        });
        [self addSubview:self.errorMsgLabel];

        self.errorRetryBtn = ({
            self.errorRetryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.errorRetryBtn.backgroundColor = [UIColor colorWithRed:25/255.0 green:169/255.0 blue:133/255.0 alpha:1];
            self.errorRetryBtn.layer.cornerRadius = 3;
            self.errorRetryBtn.layer.masksToBounds = YES;
            [self.errorRetryBtn setTitle:@"重新加载" forState:UIControlStateNormal];
            [self.errorRetryBtn addTarget:self action:@selector(errorRetryClick:) forControlEvents:UIControlEventTouchUpInside];
            self.errorRetryBtn;
        });
        [self addSubview:self.errorRetryBtn];
    }
    return self;
}

- (void)errorRetryClick:(UIButton *)sender {
    
    [[self class] setErrorHide];
    if (self.clickEventCallback) {
        self.clickEventCallback(0,self);
    }
}

+ (void)setErrorHide {
    [self sharedView].errorImageView.animatedImage = nil;
    [self sharedView].errorImageView.frame = CGRectZero;
    [self sharedView].errorMsgLabel.frame = CGRectZero;
    [self sharedView].errorRetryBtn.frame = CGRectZero;
}

//设置
+ (void)setSuperView:(UIView *)superView {
    [self sharedView].frame = superView.bounds;
    [[self sharedView].gifImageView setFrame:[self sharedView].bounds];
    [self sharedView].superView = superView;
}

//显示
+ (void)showWithGif:(NSString *)gif requestInfo:(NSDictionary *)info {
    
    if ([self sharedView].superView) {
        if ([self sharedView].isLoading.boolValue) {
            return;
        }
        [[self class] setErrorHide];
        [self sharedView].alpha = 1;
        [self sharedView].requestInfo = info;
        if ([gif containsString:@".gif"]) {
            gif = [gif substringToIndex:gif.length-4];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self sharedView].gifImageView.image = [UIImage imageWithGIFNamed:gif];
            NSURL *url1 = [[NSBundle mainBundle] URLForResource:gif withExtension:@"gif"];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
            [self sharedView].gifImageView.animatedImage = animatedImage1;
            
            if (![[self sharedView].superView.subviews containsObject:[self sharedView]]) {
                [[self sharedView].superView addSubview:[self sharedView]];
            }
        });
    } else {
        NSLog(@"未设置superview");
    }
}

+ (void)transferShowError:(NSString *)imagePath
                noticeTxt:(NSString *)noticeTxt
              requestInfo:(NSDictionary *)info
       clickEventCallback:(void(^)(NSInteger index, QKProgressHUD *hud))clickEventCallback {
    
    if ([self sharedView].superView) {
        //先判断[self sharedView]是否已加载到[self sharedView].superView
        if (![[self sharedView].superView.subviews containsObject:[self sharedView]]) {
            [[self sharedView].superView addSubview:[self sharedView]];
        }
        if ([self sharedView].isLoading.boolValue) {
            [self sharedView].isLoading = @(NO);
        }
        if (info) {
            [self sharedView].requestInfo = info;
        }
        [self sharedView].clickEventCallback = clickEventCallback;
        //隐藏gif
        [self sharedView].gifImageView.animatedImage = nil;
        
        [self sharedView].errorMsgLabel.text = noticeTxt;
        [[self sharedView].errorMsgLabel sizeToFit];
        
        CGFloat errorImageWidth,errorImageHeight;
        if ([imagePath hasSuffix:@".gif"]) {
            errorImageWidth = 200;
            errorImageHeight = 180;
            //[self sharedView].errorImageView.image = [UIImage imageWithGIFNamed:[imagePath substringToIndex:imagePath.length-4]];
            imagePath = [imagePath substringToIndex:imagePath.length-4];
            NSURL *url1 = [[NSBundle mainBundle] URLForResource:imagePath withExtension:@"gif"];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
            [self sharedView].errorImageView.animatedImage = animatedImage1;
        } else {
            errorImageWidth = 150;
            errorImageHeight = 150;
            //[self sharedView].errorImageView.image = [UIImage imageNamed:imagePath];
            NSURL *url1 = [[NSBundle mainBundle] URLForResource:imagePath withExtension:@"gif"];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
            [self sharedView].errorImageView.animatedImage = animatedImage1;
        }
        
        [[self sharedView].errorImageView setFrame:CGRectMake(([self sharedView].frame.size.width-errorImageWidth)/2, ([self sharedView].frame.size.height-errorImageHeight)/2-80, errorImageWidth, errorImageHeight)];
        [[self sharedView].errorMsgLabel setFrame:CGRectMake(0, [self sharedView].errorImageView.frame.origin.y+[self sharedView].errorImageView.frame.size.height, [self sharedView].superView.frame.size.width, [self sharedView].errorMsgLabel.frame.size.height)];
        [[self sharedView].errorRetryBtn setFrame:CGRectMake(([self sharedView].frame.size.width-80)/2, [self sharedView].errorMsgLabel.frame.origin.y+[self sharedView].errorMsgLabel.frame.size.height+20, 80, 35)];
    } else {
        NSLog(@"未设置superview");
    }
}

//隐藏
+ (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self sharedView].superView) {
            [UIView animateWithDuration:0.25 animations:^{
                [self sharedView].alpha = 0;
            } completion:^(BOOL finished) {
                [[self sharedView] removeFromSuperview];
            }];
            if ([self sharedView].isLoading.boolValue) {
                [self sharedView].isLoading = @(NO);
            }
        }
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
