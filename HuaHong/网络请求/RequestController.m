//
//  RequestController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/19.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "RequestController.h"
#import "XMLModel.h"
#import "NSString+Hash.h"

@interface RequestController ()<NSXMLParserDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
//1.可变数组
@property(nonatomic,strong)NSMutableArray *videos;

//3.拼接字符串--可变字符串
@property(nonatomic,strong)NSMutableString *elementStr;

@property (nonatomic,strong) XMLModel *model;

@property (nonatomic,strong) NSURLSession *session;

@end

@implementation RequestController

/**
                缓存策略
 NSURLRequestUseProtocolCachePolicy = 0,默认
 NSURLRequestReloadIgnoringLocalCacheData = 1,忽略本地缓存数据，直接加载网络数据
 NSURLRequestReturnCacheDataElseLoad = 2,先从缓存读取数据，若没有则加载网络
 NSURLRequestReturnCacheDataDontLoad = 3,返回缓存数据，不加载网络数据
 
 */
-(NSURLSession *)session
{
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //统一设置请求头信息
//        config.HTTPAdditionalHeaders = @{@"Authorization":[self getAuthorization:@"admin" pwd:@"901124"]};

        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue new]];
        
    }
    
    return _session;
}
-(NSMutableArray *)videos
{
    if (!_videos) {
        _videos = [[NSMutableArray alloc]init];
        
    }
    return _videos;
}

-(NSMutableString *)elementStr
{
    if (!_elementStr) {
        _elementStr = [[NSMutableString alloc]init];
        
    }
    return _elementStr;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /**
     * @property (nullable, readonly, retain) id <NSURLSessionDelegate> delegate;
     * delegate 是强引用，会造成循环引用
     */
    
    //取消任务并且使session无效
    [self.session invalidateAndCancel];
    
    //任务完成再使session无效
//    [self.session finishTasksAndInvalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self toJSON];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self loadData_Session];
    [self uploadData_SessionPUT];
}

- (void)loadData_Connection
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"demo.json"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15.0];

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {

//                NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"value:%@",value);


//        [self json:data];

//        [self plist:data];

        [self xml:data];

    }];
    
 
}

-(void)httpsRequest
{
    //https
    NSURL *url = [NSURL URLWithString:@"https://kyfw.12306.cn/otn/index/init"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15.0];
    //    [request setHTTPMethod:@"POST"];
    //    NSString *bodytext = @"hsdbhhaa";
    //    NSData *body = [bodytext dataUsingEncoding:NSUTF8StringEncoding];
    //    [request setHTTPBody:body];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"value:%@",value);
        
    }];
    
    [task resume];
}

//使用Block
-(void)loadData_Session
{
    /**
       简便写法
     */
//    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"uploads/123.jpg"];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        NSData *data = [NSData dataWithContentsOfURL:location];
//        UIImage *image = [UIImage imageWithData:data];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.view.layer.contents = (__bridge id)(image.CGImage);
//        });
//    }]resume];
    
    
}


//使用代理
-(void)loadData_Session_POST2
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"demo.json"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15.0];
//    [request setHTTPMethod:@"GET"];
//    NSString *bodytext = @"hsdbhhaa";
//    NSData *body = [bodytext dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:body];
    
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 配置NSURLSessionConfiguration属性
    /*
     requestCachePolicy：设置缓存策略
     networkServiceType：设置网络服务的类型：网络流量，网络电话，语音，视频..
     timeoutIntervalForRequest：设置超时时间
     HTTPAdditionalHeaders：设置请求头
     discretionary：用于后台请求，会把WiFi和电量的可用性考虑在内
     allowsCellularAccess：是否允许使用蜂窝数据
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url];
    
    [task resume];
}

#pragma mark - NSURLSessionDataDelegate
// 1.服务器返回响应头信息，注意：这时候相应体中的数据还没有传输完成
-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 1>取得响应包对象
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    // 2>取得响应头信息
    NSDictionary *allHeaderFields = [httpResponse allHeaderFields];
    
//    NSLog(@"%@", allHeaderFields);
    
    //选择是否继续本次回话，NSURLSessionResponseDisposition枚举值有三个选项
    completionHandler(NSURLSessionResponseAllow);
}

// 2.相应体的数据接收完成
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // data接收到的网络数据
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", dataString);
}

// 3.任务加载完成
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if(error ==nil) {
        NSLog(@"任务完成");
    }else{
        NSLog(@"error : %@", error);
    }
}

//https 证书
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(0,credential);
    }
}
#pragma mark - json解析
-(void)json:(NSData *)data
{
    
    /**
     NSJSONReadingMutableContainers 容器节点是可变的
     NSJSONReadingMutableLeaves     子节点是可变的
     NSJSONReadingAllowFragments    允许顶级节点不是NSArray Or NSDictionary
     */
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    NSLog(@"result:%@",result);

}
#pragma mark - json序列化
-(void)toJSON
{
    XMLModel *model = [[XMLModel alloc]init];
    model.name = @"huah";
    model.length = @(22);
    [model setValue:@"华宏" forKey:@"author"];
    
    NSDictionary *dic = [model dictionaryWithValuesForKeys:@[@"name",@"length",@"author"]];
    
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"str:%@",str);
    }
    
}

#pragma mark - plist解析
-(void)plist:(NSData *)data
{
    /**
     NSPropertyListImmutable 不可变
     NSPropertyListMutableContainers 容器可变
     NSPropertyListMutableContainersAndLeaves 容器和子节点都可变
     */
    id result = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:NULL];
    
    NSLog(@"result:%@",result);
}

#pragma mark - XML解析
-(void)xml:(NSData *)data
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:data];
    xmlParser.delegate = self;
    
    [xmlParser parse];
    
}

/**
 NSXMLParserDelegate
 */
//1.打开文档
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    //1.清空数组
    [self.videos removeAllObjects];
}
//2.开始节点
-(void)parser:(NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict
{
    //elementName   节点名称
    //namespaceURI  命名空间
    //qualifiedName 命名空间限定的本地名称
    //attributeDict 属性
    
    if ([elementName isEqualToString:@"video"]) {
        
        //1.新建模型
        self.model = [[XMLModel alloc]init];
        
        //2设置videoID的属性
        self.model.videoId = @([attributeDict[@"videoId"]intValue]);
        
        
    }
    
}

//3.发现节点内容
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //拼接字符串
//    NSLog(@"==> %@",string);
    [self.elementStr appendString:string];
}

//4.结束节点
-(void)parser:(NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
//    NSLog(@"4.结束节点：%@",elementName);
    
    if ([elementName isEqualToString:@"video"]) {
        
        [self.videos addObject:self.model];
        
    }else if (![elementName isEqualToString:@"videos"])
    {
        [self.model setValue:self.elementStr forKey:elementName];
        
    }
    //清空字符串
    [self.elementStr setString:@""];
}

//5.结束解析
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
//    NSLog(@"5.结束解析！%@",self.videos);
    for (XMLModel *model in self.videos) {
        NSLog(@"%@",[model description]);
    }
}

//6.错误处理
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError
{
     NSLog(@"发生错误");
}

#pragma mark - put 上传文件
-(void)uploadData_SessionPUT
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"uploads/123.mp4"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15.0];
    [request setHTTPMethod:@"put"];
    
    //Authorization    Basic YWRtaW46OTAxMTI0
    [request setValue:[self getAuthorization:@"admin" pwd:@"901124"]forHTTPHeaderField:@"Authorization"];
    
    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"weixinY.mp4" withExtension:nil];
    
    //此方法没有代理
/*
    [[[NSURLSession sharedSession]uploadTaskWithRequest:request fromFile:fileUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data:%@",str);
        
    }]resume];
    
*/
  
    
//    [[self.session uploadTaskWithRequest:request fromFile:fileUrl]resume];
    
    //此方法也可设置代理
    [[self.session uploadTaskWithRequest:request fromFile:fileUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"--data:%@",str);
        NSLog(@"--response:%@",response);

        
    }]resume];
}

-(NSString *)getAuthorization:(NSString *)userName pwd:(NSString *)pwd
{
    NSString *tmpStr = [NSString stringWithFormat:@"%@:%@",userName,pwd];
    tmpStr = [tmpStr base64Encode];
    NSString *authorizationStr = [NSString stringWithFormat:@"Basic %@",tmpStr];
    return authorizationStr;
}


/**
    NSURLSessionTaskDelegate
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    CGFloat progress = 1.0 * totalBytesSent / totalBytesExpectedToSend;
    NSLog(@"progress:%f",progress);
}

#pragma mark - delete 删除文件
-(void)deletedata
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"uploads/123.mp4"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15.0];
    [request setHTTPMethod:@"delete"];
    
    //Authorization    Basic YWRtaW46OTAxMTI0
    [request setValue:[self getAuthorization:@"admin" pwd:@"901124"]forHTTPHeaderField:@"Authorization"];
    
//    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"weixinY.mp4" withExtension:nil];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"--data:%@",str);
        NSLog(@"--response:%@",response);
    }]resume];
}


@end
