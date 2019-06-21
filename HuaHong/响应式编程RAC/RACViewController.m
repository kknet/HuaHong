//
//  RACViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "RACViewController.h"
#import "RACView.h"

@interface RACViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *anotherTextField;
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
    
//    self.racView.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    
//    [self RACSignal];
    
//    [self racCommand2];
    
    
    [self SignalMethod];
    
//    [self RACTuple];

//    [self RACSequence];
    
//    [self RACMulticastConnection];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self delegateMethod];

    [self kvo];

    [self targetEvents];

    [self notification];
    
    [self textFieldEvent];
    
    [self racDefine];
    
    [self RACObserve];
    
    [self rac_gestureSignal];
    
    [self racCommand];
    
    [self dataBinding];
    
    [self subjectMethod];
    
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
    
    
     /** RACSubject 信号提供者：自己可以充当信号，又能发送信号 */

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
    /**
     * nextBlock调用：只要订阅者发送数据、信号就会被调用
     * nextBlock作用：处理数据、展示UI
     * nextBlock是否被调用，取决于订阅者是否发送了信号
     **/
   RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
       
        NSLog(@"x:%@",x);
    }];
    
    
    /**
     * 默认一个信号发送数据完毕之后，就会主动取消订阅；
     * 只有订阅者在，就不会自动取消订阅
     * 手动取消订阅？
     **/
    [disposable dispose];
}

- (void)SignalMethod
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
//        [subscriber sendError:[NSError errorWithDomain:@"Domain" code:1 userInfo:nil]];
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"3"];
        [subscriber sendNext:@"5"];
        [subscriber sendNext:@"7"];
        [subscriber sendNext:@"9"];
        [subscriber sendCompleted];

        return nil;
    }];
    
    /**
     * 1.过滤
     * 过滤返回NO的信号
     **/
    [[signal filter:^BOOL(NSString *value) {
        
        return [value isEqualToString:@"5"] ;

    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"filter:%@",x);
    }];
    
    
    /**
     * 2.map
     * 把原始值value映射成一个新值
     **/
    [[signal map:^id _Nullable(NSString *value) {
       
        return @([value intValue] * [value intValue]);
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"map:%@",x);
    }];
    
    /**
     * 3.flattenMap
     * 根据将原来的信号映射成新信号
     **/
    [[signal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [RACSignal return:[NSString stringWithFormat:@"flattenMap:%@",value]];
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"flattenMap:%@",x);
    }];
    
    /**
     * 4.ignore
     * 忽略某个值，比如3
     **/
    [[signal ignore:@"3"]subscribeNext:^(id  _Nullable x) {
        NSLog(@"ignore:%@",x);
    }];
    
    /**
     * 5.ignore
     * 忽略所有个值，中间所有值都丢弃，只取Comletion和Error两个消息
     **/
    [[signal ignoreValues]subscribeNext:^(id  _Nullable x) {
        NSLog(@"ignoreValues:%@",x);
    }error:^(NSError *error) {
        NSLog(@"ignoreValues error");
    }completed:^{
        NSLog(@"ignoreValues completed");
    }];
    
    
    /**
     * 6.take
     * 从开始取N次信号
     **/
    [[signal take:3]subscribeNext:^(id  _Nullable x) {
        NSLog(@"take:%@",x);
    }];
    
    /**
     * 7.takeLast
     * 取最后N次的信号
     **/
    [[signal takeLast:3]subscribeNext:^(id  _Nullable x) {
        NSLog(@"takeLast:%@",x);
    }];
    
    /**
     * 8.takeUntilBlock
     * 当block返回YES时停止取值
     **/
    [[signal takeUntilBlock:^BOOL(NSString *x) {
        if ([x isEqualToString:@"5"]) {
            return YES;
        }
        
        return NO;
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"takeUntilBlock:%@",x);
    }];
    
    
    /**
     * 9.skip
     * 跳过N次信号
     **/
    [[signal skip:2]subscribeNext:^(NSString *x) {
        NSLog(@"skip:%@",x);
    }];
    
    /**
     * 10.skipUntilBlock
     * 一直跳，直到block返回YES为止
     **/
    [[signal skipUntilBlock:^BOOL(id  _Nullable x) {
        if ([x isEqualToString:@"5"]) {
            return YES;
        }
        
        return NO;
    }]subscribeNext:^(id  _Nullable x) {
       NSLog(@"skipUntilBlock:%@",x);
    }];
    
    /**
     * 11.skipWhileBlock
     * 一直跳，直到block返回NO为止，与skipUntilBlock相反
     **/
    [[signal skipWhileBlock:^BOOL(id  _Nullable x) {
        if ([x isEqualToString:@"5"]) {
            return NO;
        }
        
        return YES;
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"skipUntilBlock:%@",x);
    }];
    
    /**
     * 12.startWith
     * 在起始位置增加相应的元素
     **/
    RACSignal *addSignal = [RACSignal return:@"456"];
    [[addSignal startWith:@"123"]subscribeNext:^(id  _Nullable x) {
        NSLog(@"startWith:%@",x);
    }];
    
    /**
     * 13.reduceEach
     * 聚合：用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
     **/
    RACSignal *cSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext:RACTuplePack(@1,@3)];
        [subscriber sendNext:RACTuplePack(@2,@4)];

        return nil;
    }];
    
    [[cSignal reduceEach:^id(NSNumber *a,NSNumber *b){
        return @([a intValue] + [b intValue]);
    }]subscribeNext:^(id  _Nullable x) {
       NSLog(@"reduceEach:%@",x);
    }];
    
    /**
     * 14.Timer
     * interval:多长时间触发一次
     * onScheduler:线程
     * take:总次数
     **/
    [[[RACSignal interval:1 onScheduler:[RACScheduler scheduler]]take:1]subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@,%@",x,[NSThread currentThread]);
    }];
    
    /**
     * 15.timeout:超时
     * delay:延迟
     **/
//    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//
//        [[signal delay:2]subscribeNext:^(id  _Nullable x) {
//            NSLog(@"延迟2秒");
//        }];
//
//        return nil;
//    }]timeout:1 onScheduler:[RACScheduler mainThreadScheduler]]subscribeError:^(NSError * _Nullable error) {
//        NSLog(@"超时了");
//    }];
    
    /**
     * 16.timeout:超时
     * delay:延迟
     **/
   __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        if (i == 5) {
            [subscriber sendNext:@"success"];
        }else
        {
            i++;
            [subscriber sendError:nil];
        }
        
        return nil;
    }]retry]subscribeNext:^(id  _Nullable x) {
        NSLog(@"retry:%@",x);
    }];
    
    /**
     * 17.takeUntil
     * 直到遇到下一个信号才结束
     **/
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

        [[RACSignal interval:1 onScheduler:[RACScheduler scheduler]]subscribeNext:^(NSDate * _Nullable x) {
            [subscriber sendNext:@"正在成长"];
        }];
        return nil;
    }]takeUntil:[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"长大了");
            [subscriber sendNext:@"长大了"];
        });
        
        return nil;
    }]]subscribeNext:^(id  _Nullable x) {
        NSLog(@"takeUntil:%@",x);
    }];
    
    /**
     * 18.doNext:执行Next之前，会先执行doNext
     * doCompleted:执行sendCompleted之前，会先执行doCompleted
     **/
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"sendNext"];
        [subscriber sendCompleted];
        return nil;
    }]doNext:^(id  _Nullable x) {
        NSLog(@"doNext");
    }]doCompleted:^{
        NSLog(@"doCompleted");
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext");
    }];
    
    
    /**
     * 19.throttle
     * 节流：用来处理当某个信号发送比较频繁的情况,在某一段时间取最后一次信号
     **/
    RACSubject *throttleSignal = [RACSubject subject];
    [[throttleSignal throttle:2]subscribeNext:^(id  _Nullable x) {
        NSLog(@"throttle:%@",x);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [throttleSignal sendNext:@"aaa"];
        [throttleSignal sendNext:@"bbb"];
        [throttleSignal sendNext:@"ccc"];

    });
    
    RACSignal *aSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"3"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"aSignal清理了");
        }];
    }];
    
    RACSignal *bSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"7"];
        [subscriber sendNext:@"9"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"bSignal清理了");
        }];
    }];
    
    
    /**
     * 20.combineLatestWith
     * 条件:必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号
     **/
    RACSignal *combineSignal = [aSignal combineLatestWith:bSignal];
    [combineSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"combineLatestWith:%@",x);
    }];
    
    //3-7 3-9 第一个信号中最后一个sendnext与后面信号的所有sendnext结合起来作为一个数组，而next触发次数以bSignal中的next次数为主
//    [[[RACSignal combineLatest:@[aSignal,bSignal]]reduceEach:^id(NSString *aItem,NSString *bItem){
//        return [NSString stringWithFormat:@"%@-%@",aItem,bItem];
//    }]subscribeNext:^(id  _Nullable x) {
//        NSLog(@"combineLatest:%@",x);
//    }];
    
    RACSignal *combineReduceSignal=[RACSignal combineLatest:@[aSignal,bSignal] reduce:^id(NSString *aItem,NSString *bItem){
        return [NSString stringWithFormat:@"%@-%@",aItem,bItem];
    }];
    
    [combineReduceSignal subscribeNext:^(id x) {
        NSLog(@"合并后combineSignal的值：%@",x);
    }];
    
    
    /**
     * 21.then
     * 用来处理串行的需求
     **/
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"第一步");
        [subscriber sendCompleted];
        return nil;
    }]then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"第二步");
            [subscriber sendCompleted];
            return nil;
        }];
    }]then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"第三步");
            [subscriber sendNext:@"完成"];
            [subscriber sendCompleted];
            return nil;
        }];
    }]subscribeNext:^(id  _Nullable x) {
       NSLog(@"%@",x);
    }];
    
    
    /**
     * 22.aggregateWithStart
     * 从哪个位置开始 进行顺序两值进行操作 最后只有一个被操作后的值
     **/
    [[signal aggregateWithStart:@0 reduce:^id _Nonnull(NSString *running, NSString  *next) {
        
        return @([running intValue] + [next intValue]);
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"aggregateWithStart:%@",x);
        //1+3+5+7+9 = 25
    }];
    
    /**
     * 23.scanWithStart
     * 从哪个位置开始 然后每个位置跟前面的值进行操作 它会有根据NEXT的个数来显示对应的值
     **/
    [[signal scanWithStart:@0 reduce:^id _Nullable(NSString *running, NSString  *next) {
        
        return @([running intValue] + [next intValue]);
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"scanWithStart:%@",x);
        //1,4,9,16,25
    }];
    
    
    /**
     * 24.concat
     * concat将几个信号放进一个组里面,按顺序连接每个,每个信号必须执行sendCompleted方法后才能执行下一个信号
     **/
    [[[signal concat:aSignal]concat:bSignal]subscribeNext:^(id  _Nullable x) {
        NSLog(@"concat:%@",x);
    }];
    
    /**
     * 25.merge
     * concat每个信号必须执行sendCompleted方法后才能执行下一个信号，而merge不用
     **/
    [[RACSignal merge:@[signal,aSignal,bSignal]]subscribeNext:^(id  _Nullable x) {
        NSLog(@"merge:%@",x);
    }];
    
    /**
     * 26.zipWith
     * 压缩具有一一对应关系,以2个信号中 消息发送数量少的为主对应
     **/
    [[signal zipWith:bSignal]subscribeNext:^(RACTuple* x) {
        RACTupleUnpack(NSString *a,NSString *b) = x;
        NSLog(@"zipWith:a:%@,b:%@",a,b);
        //1,3,5,7,9      7,9
        //zipWith:1,7    3,9
    }];
    
    /**
     * 27.bind
     * 只要源信号发送数据,就会调用bindBlock
     **/
    [[signal bind:^RACSignalBindBlock _Nonnull{
        
        return ^RACSignal * (id value, BOOL *stop){
            
            //block作用:处理原信号内容
            //value:源信号发送的内容
            NSLog(@"bind value:%@",value);
            //返回信号,不能传nil , 返回空信号 :[RACSignal empty]
            return [RACSignal return:value];
        };
        
    }]subscribeNext:^(id  _Nullable x) {
         NSLog(@"bind:%@",x);
    }];
    
    /**
     * 28.distinctUntilChanged
     * 忽略掉重复数据
     **/
    [[signal distinctUntilChanged]subscribeNext:^(id  _Nullable x) {
        NSLog(@"distinctUntilChanged:%@",x);
    }];
    
    /**
     * 29.mapReplace
     *
     **/
    
    
    /**
     * 30.deliverOn
     * 执行在xx线程
     **/
    [[signal deliverOn:[RACScheduler scheduler]]subscribeNext:^(id  _Nullable x) {
        
    }];
    //处理当界面有多次请求时，需要都获取到数据时，才能展示界面
    [self rac_liftSelector:@selector(updateUIWithOneData:TwoData:) withSignalsFromArray:@[aSignal,bSignal]];
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

#pragma mark - RACReplaySubject
-(void)RACReplaySubject
{
    //RACSubject必须要先订阅信号之后才能发送信号，而RACReplaySubject可以先发送信号后订阅
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    //订阅和发送步骤可替换
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [replaySubject sendNext:@"RACReplaySubject"];
}

#pragma mark - subject
- (void)subjectMethod
{
    //这么写,可以解决cell复用问题
    self.racView.subject = [RACSubject subject];
    [self.racView.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"x:%@",x);
    }];
}

#pragma mark - 替代代理
-(void)delegateMethod
{
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@",x);
        UITextField *textField = x.first;
        [textField resignFirstResponder];
    }];
    
    self.textField.delegate = self;
    
    
    //监听view的方法
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
-(void)kvo
{
    [self.racView rac_observeKeyPath:@"backgroundColor" options:(NSKeyValueObservingOptionNew) observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        NSLog(@"接收到kvo");
    }];
    
    [[self.racView rac_valuesForKeyPath:@"backgroundColor" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"kvo2,直接接收到变化的值：%@",x);
    }];
    
    [[self.racView rac_valuesAndChangesForKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew observer:self]subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"rac_valuesAndChangesForKeyPath");
    }];
}

#pragma mark - 监听事件
-(void)targetEvents
{
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"监听事件:%@",x);
    }];
}

#pragma mark - 通知 为啥调用多次？
-(void)notification
{
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification * _Nullable x) {
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

#pragma mark - RAC的宏
-(void)racDefine
{
   //用来给某个对象的某个属性赋值
    RAC(_label,text) = _textField.rac_textSignal;
}

-(void)RACObserve
{
    //监听对象属性，可替代kvo
    @weakify(self)
    [RACObserve(_racView, backgroundColor)subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSLog(@"RACObserve监听对象属性：%@",x);
    }];
}

#pragma mark - 元祖
-(void)RACTuple
{
    NSArray *arr = @[@"abc",@"321",@(123)];
    RACTuple *tupleA = [RACTuple tupleWithObjectsFromArray:arr];
    RACTuple *tupleB = RACTuplePack(@10,@20);
    RACTuple *tupleC = [RACTuple tupleWithObjects:@1,@2,@3, nil];
    NSString *str = [tupleA objectAtIndex:1];
    RACTupleUnpack(NSNumber *a,NSNumber *b) = tupleB;
    NSLog(@"str:%@,a:%@,b:%@",str,a,b);
    NSLog(@"array:%@",tupleA.allObjects);

}

#pragma mark - 集合
-(void)RACSequence
{
    NSArray *arr = @[@"1",@"2",@"3",@"4",@"5"];
    
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    NSDictionary *dic = @{@"name":@"huahong",@"age":@(18)};
    //字典转为集合
    [dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        //解析元祖
        RACTupleUnpack(NSString *key,id value) = x;
        
        NSLog(@"key:%@,value:%@",key,value);
        
        
    }];
    
    //RAC集合 将数组中的元素作为发送信号的内容
    RACSequence *sequence = [arr rac_sequence];
    RACSequence *newSequence;
    
    /** 把原始值value映射成一个新值 */
   newSequence = [sequence map:^id _Nullable(id  _Nullable value) {
        return @([value intValue] * 2);
    }];
    
    /** 过滤返回NO的信号 */
  newSequence =  [sequence filter:^BOOL(id  _Nullable value) {
        return [value integerValue]%2 == 0;
    }];
    
    
    //Left12345 foldRightWithStart同理
    id data = [sequence foldLeftWithStart:@"Left" reduce:^id _Nullable(id  _Nullable accumulator, id  _Nullable value) {
        return [accumulator stringByAppendingString:value];
    }];
    NSLog(@"data:%@",data);
    
    /** 跳过前N次信号 */
    newSequence =  [sequence skip:2];
    
    /** 取N次信号 */
    newSequence =  [sequence take:3];

    /** 一直获取信号，直到block返回YES */
    newSequence =  [sequence takeUntilBlock:^BOOL(id  _Nullable x) {
        return [x integerValue] == 4;
    }];

    RACSequence *nextSequence = newSequence.array.rac_sequence;

    /** 合并 */
    newSequence =  [sequence concat:nextSequence];
    

    NSLog(@"array:%@",newSequence.array);
    
     
}


-(void)rac_plist
{
    
    //解析Plist路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"kfc.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [dictArr.rac_sequence.signal subscribeNext:^(NSDictionary * x) {
        
        Model *model = [[Model alloc]initWithDict:x];
        [arr addObject:model];
        
    }];
    
    //或者这样遍历数组，并且将模型添加到数组
    NSArray *arr2 = [[dictArr.rac_sequence map:^id _Nullable(NSDictionary * value) {
        
        return [[Model alloc]initWithDict:value];
    }] array];
     
    
}

#pragma mark - 手势
-(void)rac_gestureSignal
{
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [self.racView addGestureRecognizer:tap];
    
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        NSLog(@"rac_gestureSignal:%@",x);
    }];
    
}

#pragma mark UIDatePicker
-(void)datePicker
{
    UIDatePicker *_datePicker = [UIDatePicker new];
    [[_datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIDatePicker * _Nullable x) {
       NSDate *_tmpDate = x.date;
    }];
}

#pragma mark - RACCommand
-(void)racCommand
{
    self.command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
         return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //参数
            NSLog(@"参数:%@",input);
            
            //处理事情，比如网络请求
            
            [subscriber sendNext:@"command data"];
            [subscriber sendCompleted];
            
//            [subscriber sendError:nil];
            
            return nil;
            
        }];
        
        
    }];
    
    
    [[self.command execute:@{@"key":@"commad key"}]subscribeNext:^(id  _Nullable x) {
        NSLog(@"x:%@",x);
    }];
    
    
    
        //订阅信号2 第一个x为signal 第一次点击没反应，
//        [self.command.executionSignals subscribeNext:^(id  _Nullable x) {
//
//            [x subscribeNext:^(id  _Nullable x) {
//               NSLog(@"x:%@",x);
//            }];
//
//        }];
    
    
//     switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
        [self.command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            NSLog(@"x:%@",x);
        }];
    
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

//RACMulticastConnection 避免多次网络请求的问题
- (void)RACMulticastConnection
{
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"send next");
        [subscriber sendNext:@"111"];
        return nil;
    }];
    
    //2.创建连接
    RACMulticastConnection *connection = [signal publish];
    
    //3.订阅信号
    [connection.signal subscribeNext:^(id  _Nullable x) {
         NSLog(@"订阅信号1");
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号2");
    }];
    
    //4.连接
    [connection connect];
}

- (void)updateUIWithOneData:(id )oneData TwoData:(id )twoData
{
    //每一个signal都至少sendNext过一次
    //方法的参数:必须和数组的信号一一对应!!
    //方法的参数:就是每一个信号发送的数据!!
    
    NSLog(@"currentThread：%@",[NSThread currentThread]);
    //拿到数据更新UI
    NSLog(@"UI!!%@%@",oneData,twoData);
    
}

- (void)dataBinding
{
    [_textField.rac_newTextChannel subscribe:_anotherTextField.rac_newTextChannel];
    [_anotherTextField.rac_newTextChannel subscribe:_textField.rac_newTextChannel];
    

    RACChannelTo(self,title) = RACChannelTo(self.textField,text);
    [self.textField.rac_textSignal subscribe:RACChannelTo(self,title)];
    
}
@end
