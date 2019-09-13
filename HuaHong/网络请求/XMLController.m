//
//  XMLController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "XMLController.h"
#import "XMLModel.h"

@interface XMLController ()<NSXMLParserDelegate>

//1.可变数组
@property(nonatomic,strong)NSMutableArray *videos;

//2.拼接字符串--可变字符串
@property(nonatomic,strong)NSMutableString *elementStr;

//3.XMLModel
@property (nonatomic,strong) XMLModel *model;

@end

@implementation XMLController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self loadData_Connection];
}
- (void)loadData_Connection
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"language.xml"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        //                NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //                NSLog(@"value:%@",value);
        
        
        [self xml:data];
        
    }];
    
    
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



@end
