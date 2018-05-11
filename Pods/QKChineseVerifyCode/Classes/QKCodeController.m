//
//  CodeController.m
//  Code
//
//  Created by Sunny on 24/4/18.
//  Copyright © 2018年 Sunny. All rights reserved.
//

#import "QKCodeController.h"
#import "QKCodeLogic.h"
#import "QKChineseVerifyCodeFramework.h"

@interface QKCodeController (){
    
}



@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet QKCodeSelectedButton *button1;
@property (weak, nonatomic) IBOutlet QKCodeSelectedButton *button2;
@property (weak, nonatomic) IBOutlet QKCodeSelectedButton *button3;
@property (weak, nonatomic) IBOutlet QKCodeSelectedButton *button4;
@property (weak, nonatomic) IBOutlet QKCodeSelectedButton *button5;
@property (weak, nonatomic) IBOutlet QKCodeSelectedButton *button6;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;


@property(nonatomic,copy)NSArray *allChinese;
@property(nonatomic,assign)NSInteger allChineseCount;
@property(nonatomic,assign)NSInteger chinese1Index;
@property(nonatomic,assign)NSInteger chinese2Index;
@property(nonatomic,assign)NSInteger chinese3Index;
@property(nonatomic,assign)NSInteger chinese4Index;
@property(nonatomic,assign)NSInteger chinese5Index;
@property(nonatomic,assign)NSInteger chinese6Index;

@property(nonatomic,assign)NSInteger red1Index;
@property(nonatomic,assign)NSInteger red2Index;
@property(nonatomic,assign)NSInteger red3Index;

@end

@implementation QKCodeController

/** 实例化 codeController*/
+(instancetype)codeControllerWithDismissCallback:(DismissSuceessBlock)dismissCallBack{
    NSBundle *chineseCodeFramework =  [QKChineseVerifyCodeFramework frameworkBundle];
    QKCodeController *codeController = [[QKCodeController alloc] initWithNibName:@"QKCodeController" bundle:chineseCodeFramework];
    codeController.dismissCallBack = dismissCallBack;
    return codeController;
        
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupInit];
    }
    return self;
}


- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupInit];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self refreshButtonClick:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------- 私有方法 ↓ -
/** 初始化 定义 present controller 动画 */
-(void)setupInit{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationCustom;
}

-(void)setup{
     [self setupUI];
    [self setupData];
   
}
-(void)setupData{
    self.allChinese = @[@"床",@"前",@"明",@"月",@"光",@"疑",@"是",@"地",@"上",@"霜",@"举",@"头",@"望",@"低",@"头",@"思",@"故",@"乡"];
    self.allChineseCount = [self.allChinese count];
}
-(void)setupUI{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.lblTitle.text];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"红色字符"].location, [[noteStr string] rangeOfString:@"红色字符"].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    //设置颜色
    [self.lblTitle setAttributedText:noteStr];
    
     self.lblTip.text = @"";
    
    
    [self.button1 setTitle:@"" forState:UIControlStateNormal];
    [self.button2 setTitle:@"" forState:UIControlStateNormal];
    [self.button3 setTitle:@"" forState:UIControlStateNormal];
    [self.button4 setTitle:@"" forState:UIControlStateNormal];
    [self.button5 setTitle:@"" forState:UIControlStateNormal];
    [self.button6 setTitle:@"" forState:UIControlStateNormal];

}
-(void)refreshButtons{
    self.button1.selected = NO;
    self.button2.selected  = NO;
    self.button3.selected  = NO;
    self.button4.selected  = NO;
    self.button5.selected  = NO;
    self.button6.selected  = NO;
    
  
}
/** 随机中文 */
-(void)randomChinese{
    /** 获取6个不相同的随机数 */
    NSArray *indexTmpArr = [QKCodeLogic randomWithBiggestNum:self.allChineseCount Num:6];
    
    if([indexTmpArr count] == 6){
        self.chinese1Index = [[indexTmpArr objectAtIndex:0] integerValue];
         self.chinese2Index = [[indexTmpArr objectAtIndex:1] integerValue];
         self.chinese3Index = [[indexTmpArr objectAtIndex:2] integerValue];
         self.chinese4Index = [[indexTmpArr objectAtIndex:3] integerValue];
         self.chinese5Index = [[indexTmpArr objectAtIndex:4] integerValue];
         self.chinese6Index = [[indexTmpArr objectAtIndex:5] integerValue];
    }
    NSLog(@"indexTmpMuArr=%@",indexTmpArr);
}

-(void)reandomRedIndex{
    NSArray *redIndexTmpArr = [QKCodeLogic randomWithBiggestNum:6 Num:3];
    NSArray *orderArr = [redIndexTmpArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         return [obj1 compare:obj2]; //升序
    }];
    if (orderArr.count == 3) {
        self.red1Index = [[orderArr objectAtIndex:0] integerValue];
        self.red2Index = [[orderArr objectAtIndex:1] integerValue];
        self.red3Index = [[orderArr objectAtIndex:2] integerValue];
    }
}
-(void)refresh6ButtonsTitle{
    [self.button1 setTitle:[self.allChinese objectAtIndex:self.chinese1Index] forState:UIControlStateNormal];
    [self.button2 setTitle:[self.allChinese objectAtIndex:self.chinese2Index] forState:UIControlStateNormal];
    [self.button3 setTitle:[self.allChinese objectAtIndex:self.chinese3Index] forState:UIControlStateNormal];
    [self.button4 setTitle:[self.allChinese objectAtIndex:self.chinese4Index] forState:UIControlStateNormal];
    [self.button5 setTitle:[self.allChinese objectAtIndex:self.chinese5Index] forState:UIControlStateNormal];
    [self.button6 setTitle:[self.allChinese objectAtIndex:self.chinese6Index] forState:UIControlStateNormal];
    
    
    if ((self.red1Index == 0) || (self.red2Index == 0) || (self.red3Index == 0)) {
        [self.button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if ((self.red1Index == 1) || (self.red2Index == 1) || (self.red3Index == 1)) {
        [self.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if ((self.red1Index == 2) || (self.red2Index == 2) || (self.red3Index == 2)) {
        [self.button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if ((self.red1Index == 3) || (self.red2Index == 3) || (self.red3Index == 3)) {
        [self.button4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [self.button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if ((self.red1Index == 4) || (self.red2Index == 4) || (self.red3Index == 4)) {
        [self.button5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [self.button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if ((self.red1Index == 5) || (self.red2Index == 5) || (self.red3Index == 5)) {
        [self.button6 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [self.button6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(BOOL)checkWithRedIndex:(NSInteger)redIndex {
    QKCodeSelectedButton *button ;
    switch (redIndex) {
        case 0:
            {
                button = self.button1;
            }
            break;
        case 1:
        {
            button = self.button2;
        }
            break;
        case 2:
        {
            button = self.button3;
        }
            break;
        case 3:
        {
            button = self.button4;
        }
            break;
        case 4:
        {
            button = self.button5;
        }
            break;
        case 5:
        {
            button = self.button6;
        }
            break;
            
        default:
            break;
    }
    
    
    if (self.red1Index == redIndex || self.red2Index == redIndex || self.red3Index ==redIndex) {
        if (button.selected == YES) {
            return YES;
        }else{
            return NO;
        }
    }else{
        if (button.selected == NO) {
            return YES;
        }else{
            return NO;
        }
    }
    
    
}
#pragma mark --------- 私有方法  end ↑ -

- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.dismissCallBack) {
            self.dismissCallBack(NO);
        }
    }];
}

- (IBAction)refreshButtonClick:(id)sender {
    [self refreshButtons];
    [self randomChinese ];
    [self reandomRedIndex];
    [self refresh6ButtonsTitle];
    self.lblTip.text = @"";
}

- (IBAction)sureButtonClick:(id)sender {
   
    for (int i=0 ; i<6; i++) {
        BOOL redSelected =  [self checkWithRedIndex:i];
        if (redSelected == NO) {
            self.lblTip.text = @"文字选择不正确";
            return ;
        }
    }
    self.lblTip.text = @"文字选择正确";
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.dismissCallBack) {
            self.dismissCallBack(YES);
        }
    }];
    
}




#pragma mark --------- 点击事件 ↓ -

- (IBAction)buttonClick:(QKCodeSelectedButton *)sender {
    sender.selected = !sender.selected;
    self.lblTip.text = @"";
}
#pragma mark --------- 点击事件  end ↑ -
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
