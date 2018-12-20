//
//  StrategyController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "StrategyController.h"
#import "CustomTextField.h"
#import "LatterValidate.h"
#import "NumberValidate.h"
@interface StrategyController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet CustomTextField *LatterTextField;
@property (strong, nonatomic) IBOutlet CustomTextField *NumberTextField;

@end

@implementation StrategyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.LatterTextField.delegate = self;
    self.NumberTextField.delegate = self;
    
    self.LatterTextField.inputValidate = [LatterValidate new];
    self.NumberTextField.inputValidate = [NumberValidate new];
}

- (IBAction)btnClick:(id)sender
{
    [self.view endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"myText:%@",textField.text);
    if ([textField isKindOfClass:[CustomTextField class]]) {
        
        [(CustomTextField *)textField validate];
    }
}
@end
