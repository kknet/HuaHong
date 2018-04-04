//
//  RACViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "RACViewController.h"
#import "RACView.h"

@interface RACViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet RACView *racView;
@property (nonatomic,strong)id <RACSubscriber> subscriber;
@property (nonatomic,strong) RACCommand *command;
//@property (strong, nonatomic) RACDisposable *disposable;

@end

@implementation RACViewController
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    self.racView.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    
//    [self RACSignal];

//    [self racTimer];
    
    [self racCommand2];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self delegateMethod];
//
//    [self kvo2];
//
    [self targetEvents];
//
//    [self notification];
    
//    [self textFieldEvent];
    
//    [self racDefine];
    
//    [self RACObserve];
    
    [self rac_gestureSignal];
    
    [self racCommand];
    
}

- (void)RACSignal
{
    
    /*
     RACSignal：信号类
     1.通过RACSignal 创建1个信号（默认：冷信号）
     2.通过订阅者，订阅信号信号（变成:热信号）
     3.发送信号
     */
    
    //1.创建信号
    /*
     didSubScriber调用：只要一个信号被订阅就调用！
     didSubScriber作用：利用subscriber 来发送数据！
     didSubScriber能否执行，取决于信号是否被订阅
     */
    
    /*
     RACDisposable：它是帮助我们取消订阅！
     什么时候需要取消订阅？
     1、信号发送完毕;
     2、信号发送失败;
     
     */
    
    /*
     RACSubject 信号提供者：自己可以充当信号，又能发送信号
     */

  //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //3.发送信号
        [subscriber sendNext:@"hello"];
        
        //这样不会被释放，不会自动取消订阅
        _subscriber = subscriber;
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
    
    //2.订阅信号（热信号）
    /*
     nextBlock调用：只要订阅者发送数据、信号就会被调用
     nextBlock作用：处理数据、展示UI
     nextBlock是否被调用，取决于订阅者是否发送了信号
     */
   RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
       
        NSLog(@"x:%@",x);
    }];
    
    
    //默认一个信号发送数据完毕之后，就会主动取消订阅；
    //只有订阅者在，就不会自动取消订阅
    //手动取消订阅？
    [disposable dispose];
}

-(void)RACSubject
{
    //1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    //2.订阅信号
    //不同的信号，订阅方式不一样（因为类型不一样，所以调用方法不一样）
    //RACSubject 处理订阅：拿到之前的_subScribers数组，保存订阅者
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"aaa接收信号：%@",x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"bbb接收信号：%@",x);
    }];
    
    //3.发送信号
    //遍历出所有的数据，调用nextBlock
    [subject sendNext:@"hello"];
}

#pragma mark - Instead of delegate Method
/*
-(void)delegateMethod
{
    //2.订阅信号
    [self.racView.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收信号：%@",x);

    }];
}
*/
-(void)delegateMethod
{
    [[self.racView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"接收信号：%@",x);
        UIButton *sender = [x first];
        
        [self sendVerificationCode:sender];
    }];
}

//模拟发送验证码
-(void)sendVerificationCode:(UIButton *)sender
{
    static NSInteger _time = 10;
    sender.enabled = NO;
    
    RACDisposable *disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]]subscribeNext:^(NSDate * _Nullable x) {
        
        NSString *text = _time > 0 ? [NSString stringWithFormat:@"请等待%ld秒",(long)_time]: @"重新发送";
        
        if (_time > 0)
        {
            sender.enabled = NO;
            [sender setTitle:text forState:UIControlStateDisabled];
        }else
        {
            sender.enabled = YES;
            [sender setTitle:text forState:UIControlStateNormal];
            [disposable dispose];
            
        }
        
        _time--;
    }];
    
}

#pragma mark - KVO
-(void)kvo1
{
    [self.racView rac_observeKeyPath:@"backgroundColor" options:(NSKeyValueObservingOptionNew) observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        NSLog(@"接收到kvo");
    }];
}

-(void)kvo2
{
    [[self.racView rac_valuesForKeyPath:@"backgroundColor" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"kvo2,直接接收到变化的值：%@",x);
    }];
}

#pragma mark - 监听事件
-(void)targetEvents
{
    //(UIControlEventTouchUpInside):有无括号均可
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"监听事件:%@",x);
    }];
}

#pragma mark - 通知 为啥调用多次？
-(void)notification
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"接收到通知");
    }];
}

-(void)textFieldEvent
{
    [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"textField:%@",x);
    }];
    
    /* 添加监听条件 */
    [[_textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        
        // 表示输入文字长度 > 5 时才会调用下面的 block
        return value.length > 5;
        
    }] subscribeNext:^(NSString * _Nullable x) {
        
        NSLog(@"输入框内容：%@", x);
    }];
    
}

#pragma mark - Timer
-(void)racTimer
{
    [[RACSignal interval:1.0 onScheduler:[RACScheduler scheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@,%@",x,[NSThread currentThread]);
    }];
}

#pragma mark - RAC的宏
-(void)racDefine
{
   //用来给某个对象的某个属性赋值
    RAC(_label,text) = _textField.rac_textSignal;
}

-(void)RACObserve
{
    //监听对象属性，可替代kvo
    [RACObserve(_racView, backgroundColor)subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACObserve监听对象属性：%@",x);
    }];
}

#pragma mark - 元祖
-(void)tuple
{
    NSArray *arr = @[@"abc",@"321",@(123)];
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:arr];
    NSString *str = [tuple objectAtIndex:1];
}

#pragma mark - 集合
-(void)sequence_array
{
    NSArray *arr = @[@"abc",@"321",@(123)];
    
    //RAC集合 将数组中的元素作为发送信号的内容
//    RACSequence *sequence = [arr rac_sequence];
//    RACSignal *signal = [sequence signal];
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
}

-(void)sequence_dictionary
{
    NSDictionary *dic = @{@"name":@"huahong",@"age":@(18)};
    //字典转为集合
    [dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
//        NSString *key = x[0];
//        NSString *value = x[1];
        
        //解析元祖： RACTupleUnpack(<#...#>)
        RACTupleUnpack(NSString *key,id value) = x;
        
        NSLog(@"key:%@,value:%@",key,value);
        
        
    }];
}

-(void)rac_plist
{
    /*
    //解析Plist路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"kfc.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [dictArr.rac_sequence.signal subscribeNext:^(NSDictionary * x) {
        
        KFC *kfc = [KFC KFCWithDict:x];
        [arr addObject:kfc];
        
    }];
    
    //或者这样遍历数组，并且将模型添加到数组
    NSArray *arr2 = [[dictArr.rac_sequence map:^id _Nullable(NSDictionary * value) {
        
        return [KFC KFCWithDict:value];
    }] array];
     
     */
}

#pragma mark - 手势
-(void)rac_gestureSignal
{
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        NSLog(@"rac_gestureSignal:%@",x);
    }];
    [self.racView addGestureRecognizer:tap];
}

#pragma mark UIDatePicker
-(void)datePicker
{
    UIDatePicker *_datePicker = [UIDatePicker new];
    [[_datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIDatePicker * _Nullable x) {
       NSDate *_tmpDate = x.date;
    }];
}

#pragma mark - RACReplaySubject
-(void)RACReplaySubject
{
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    //订阅和发送步骤可替换
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [replaySubject sendNext:@"RACReplaySubject"];
}

#pragma mark - RACCommand
-(void)racCommand
{
    self.command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //参数
            NSLog(@"参数:%@",input);
            
            //处理事情，比如网络请求
            
            [subscriber sendNext:@"command data"];
            [subscriber sendCompleted];
            
//            [subscriber sendError:nil];
            
            return nil;
            
        }];
        
//        return signal;//直接返回sendNext数据
        
        //可对sendNext发送的数据处理，然后返回
        return [signal map:^id _Nullable(id  _Nullable value) {
            NSLog(@"value:%@",value);
            return value;
        }];
        
    }];
}

-(void)racCommand2
{
    RACSignal *signal = [self.command execute:@{@"key":@"commad key"}];
    
    //订阅信号1
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"x:%@",x);
    }];
    
    
//    //订阅信号2 第一个x为signal 第一次点击没反应，
//    [self.command.executionSignals subscribeNext:^(id  _Nullable x) {
//
//        [x subscribeNext:^(id  _Nullable x) {
//           NSLog(@"x:%@",x);
//        }];
//
//    }];
    
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
//    [self.command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"x:%@",x);
//    }];
    
     //监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[_command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    
    
}
@end
