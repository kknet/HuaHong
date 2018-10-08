//
//  LoginViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/19.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *pwdTF;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UISwitch *myswitch;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取出用户名/密码
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"username"];
    NSString *pwd = [userDefaults objectForKey:@"pwd"];
    self.userNameTF.text = name.length? name:@"";
    self.pwdTF.text = pwd.length? pwd:@"";
    [self textChanged];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:self.userNameTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:self.pwdTF];
}

-(void)textChanged
{
    self.loginBtn.enabled = (self.userNameTF.text.length && self.pwdTF.text.length);
}
- (void)remberPassword
{
    if (self.myswitch.isOn)
    {
       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.userNameTF.text forKey:@"username"];
        [userDefaults setObject:self.pwdTF.text forKey:@"pwd"];
        [userDefaults synchronize];
                
    }
}

- (IBAction)loginAction:(id)sender
{
    if (!self.userNameTF.text.length)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    
    if (!self.pwdTF.text.length)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    
    if ([self.userNameTF.text isEqualToString:@"huahong"] && [self.pwdTF.text isEqualToString:@"901124"]) {
        
        [SVProgressHUD showInfoWithStatus:@"正在登录中..."];
        [self remberPassword];
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:@"LoginToCantact" sender:nil];

        });
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"用户名或密码不正确"];
        return;
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    LoginViewController *loginVC = segue.destinationViewController;
    loginVC.title = [NSString stringWithFormat:@"%@的联系人",self.userNameTF.text];
}

-(IBAction)back:(UIStoryboardSegue *)segue
{
    
}
@end
