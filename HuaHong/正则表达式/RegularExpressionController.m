//
//  RegularExpressionController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "RegularExpressionController.h"

@interface RegularExpressionController ()

@end

@implementation RegularExpressionController

/**
 练习1:匹配abc
 @"abc";
 
 练习2:包含一个小写a~z,后面必须是0~9
 @"[a-z][0-9]";
 
 练习3:必须第一个是字母,第二个必须是数字
 @"^[a-z][0-9]$";
 
 练习4:必须第一个是字母,字母后面跟上4~9个数字
 @"^[a-z][0-9]{4,9}$";
 
 练习5:不能是数字开头
 @"^[^0-9]";
 
 练习6:QQ匹配
 1. 5~12位
 2. 纯数字
 
 练习7:手机号码匹配
 1.以13/15/17/18
 2.长度是11
 */

/**
 []    : 括号内方的是匹配的条件 , 一般来说, 一个[], 就代表匹配一位
 [a-z] : 匹配小写 a~z
 [0-9] : 匹配0~9的数字   另外一种写法 \d == [0-9]
 ^     : 代表已后面的匹配条件为开头
 $     : 代表以前面一个匹配条件为结果
 {}    : 里面写的是查询次数的条件  {4,9}最少4次, 最多9次  / {4,}最少4此, 最多不限
 ^[^0-9]: ^写在[]内, 就代表不能以括号内的条件作为开头
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self predicate];
}

//正则匹配
-(void)RegularExpression
{
    //1. 获取一个要匹配的字符串
    NSString *URLStr = @"1234324";
    
    //2. Pattern : 正则表达式语句 (语法规则)
    NSString *pattern = @"^[1-9][0-9]{4,11}$";
    
    //3. 创建正则表达式对象
    //NSRegularExpression 正则表达式对象
    //NSRegularExpressionCaseInsensitive: 忽略大小写
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    //4. 匹配
    // 只匹配一次
    //regex firstMatchInString:<#(nonnull NSString *)#> options:<#(NSMatchingOptions)#> range:<#(NSRange)#>
    
    // 匹配多次结果
    //matchesInString: 需要匹配的字符串
    //options: NSMatchingReportCompletion 一般使用这个, 匹配到了就会返回结果
    //range : 范围
    NSArray *resultArray = [regex matchesInString:URLStr options:NSMatchingReportCompletion range:NSMakeRange(0, URLStr.length)];
    
    //5. 获取匹配到的数据
    if (resultArray.count) {
        // 匹配到了结果
        NSLog(@"匹配到了结果, 有% ld 个", resultArray.count);
    } else {
        // 没有匹配到结果
        NSLog(@"没有匹配的结果");
    }
}

// 谓词匹配
-(void)predicate
{
    
        NSString *str = @"jkjj9803418";
    
        NSString * regex = @"^[A-Za-z]+[0-9]*$";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:str];
    
    
    NSString *result = isMatch ? @"验证成功" : @"验证失败";
    NSLog(@"%@",result);
}
@end
