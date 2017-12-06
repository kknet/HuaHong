//
//  CustomContactsController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/6.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "CustomContactsController.h"
#import <ContactsUI/ContactsUI.h>
#import "ContactModel.h"

@interface CustomContactsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *contactList;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CustomContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"自定义通讯录" style:UIBarButtonItemStylePlain target:self action:@selector(customerContact)];

}

#pragma mark - 自定义通讯录
-(void)customerContact
{
    
    //判断授权状态
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined)
    {
        // 2. 获取联系人仓库
        CNContactStore *store = [[CNContactStore alloc]init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted)
            {
                
                [self getContactList];
                
            }else
            {
                NSLog(@"未授权");
            }
        }];
    }else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)
    {
        [self getContactList];
    }
}

-(void)getContactList
{
    if (self.contactList.count) {
        [self.contactList removeAllObjects];
    }
    
    [self.view addSubview:self.tableView];
    
    CNContactStore *store = [[CNContactStore alloc]init];
    // 3. 创建联系人信息的请求对象
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey];
    
    // 4. 根据请求Key, 创建请求对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keys];
    
    // 5. 发送请求
    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        ContactModel *model = [[ContactModel alloc]init];
        
        // 6.1 获取姓名
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSString *name = [givenName stringByAppendingString:familyName];
        model.name = name;
        NSLog(@"givenName:%@--familyName:%@", givenName, familyName);
        
        // 6.2 获取电话
        NSArray *phoneArr = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneArr) {
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSLog(@"phoneNumber:%@",phoneNumber.stringValue);
            model.phone = phoneNumber.stringValue;
        }
        
        //获取头像缩略图
        if ([contact isKeyAvailable:CNContactThumbnailImageDataKey]) {
            NSData *thumImageData = contact.thumbnailImageData;
            UIImage *headImage = [UIImage imageWithData:thumImageData];
            model.headImage = headImage;
        }
        [self.contactList addObject:model];
        [self.tableView reloadData];
        
    }];
}
-(NSMutableArray *)contactList
{
    if (_contactList == nil) {
        _contactList = [NSMutableArray array];
    }
    
    return _contactList;
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    ContactModel *model = (ContactModel *)[self.contactList objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.phone;
    if (model.headImage) {
        cell.imageView.image = model.headImage;
    }else
    {
        cell.imageView.image = [UIImage imageNamed:@"portrait_image"];
        
    }
    return cell;
}

@end
