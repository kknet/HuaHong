//
//  ContactsController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/5.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "ContactsController.h"
#import <ContactsUI/ContactsUI.h>

@interface ContactsController ()<CNContactPickerDelegate>

@end

@implementation ContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"通讯录";
    
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"系统通讯录" style:UIBarButtonItemStylePlain target:self action:@selector(systemContact)];
    
    
}

-(void)systemContact
{
    CNContactPickerViewController *vc = [[CNContactPickerViewController alloc]init];
    vc.delegate = self;
    vc.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - 选中一个联系人
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
//    NSLog(@"contact:%@",contact);
    //phoneNumbers 包含手机号和家庭电话等
    for (CNLabeledValue *lableValue in contact.phoneNumbers) {
        CNPhoneNumber *phoneNumber = lableValue.value;
        NSLog(@"phoneNumber:%@",phoneNumber.stringValue);

    }

    NSLog(@"name:%@",contact.familyName);


}

#pragma mark - 选中一个联系人属性
//-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
//{
////    NSLog(@"contactProperty:%@",contactProperty);
//
//    if ([contactProperty.key isEqualToString:@"phoneNumbers"])
//    {
//        CNPhoneNumber *phoneNumber = contactProperty.value;
//        NSLog(@"phoneNumber:%@",phoneNumber.stringValue);
//
//    }else if ([contactProperty.key isEqualToString:@"postalAddresses"])
//    {
//        CNPostalAddress *address = contactProperty.value;
//        NSLog(@"address:%@",address.street);
//    }else
//    {
//        NSLog(@"value:%@",contactProperty.value);
//    }
//
//    NSLog(@"name:%@",contactProperty.contact.familyName);
//}

#pragma mark - 选中多个联系人
//-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts
//{
//    NSLog(@"contacts:%@",contacts);
//    for (CNContact *contact in contacts)
//    {
//        NSLog(@"name:%@",contact.familyName);
//
//        for (CNLabeledValue *lableValue in contact.phoneNumbers)
//        {
//            CNPhoneNumber *phoneNumber = lableValue.value;
//            NSLog(@"phoneNumber:%@",phoneNumber.stringValue);
//
//        }
//
//    }
//
//}

#pragma mark - 选中多个联系人属性
//-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty *> *)contactProperties
//{
//    NSLog(@"contactProperties:%@",contactProperties);
//
//    for (CNContactProperty *contactProperty in contactProperties)
//    {
//        NSLog(@"name:%@",contactProperty.contact.familyName);
//
//            if ([contactProperty.key isEqualToString:@"phoneNumbers"])
//            {
//                CNPhoneNumber *phoneNumber = contactProperty.value;
//                NSLog(@"phoneNumber:%@",phoneNumber.stringValue);
//
//            }else if ([contactProperty.key isEqualToString:@"postalAddresses"])
//            {
//                CNPostalAddress *address = contactProperty.value;
//                NSLog(@"address:%@",address.street);
//            }else
//            {
//                NSLog(@"value:%@",contactProperty.value);
//            }
//
//    }
//
//}


@end
