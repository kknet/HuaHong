//
//  CBPeripheralViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/19.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CBPeripheralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID @"68753A44-4D6F-1226-9C60-0050E4C00067"
#define CHARACTERISTIC_UUID @"68753A44-4D6F-1226-9C60-0050E4C00067"

@interface CBPeripheralViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CBPeripheralManagerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;

@end

@implementation CBPeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)selectPhoto:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        return;
    }
    
    UIImagePickerController *pick = [UIImagePickerController new];
    pick.delegate = self;
    pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pick animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)connectAction:(id)sender
{
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
}
- (IBAction)sendAction:(id)sender
{
//    [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:@"serviceUUID"]],CBAdvertisementDataLocalNameKey:@"huahong"}];
    
    
  BOOL success = [self.peripheralManager updateValue:UIImagePNGRepresentation(self.imageView.image) forCharacteristic:self.characteristic onSubscribedCentrals:nil];
    
    if (success) {
        NSLog(@"数据发送成功");
        [SVProgressHUD showSuccessWithStatus:@"数据发送成功"];
    }else {
        NSLog(@"数据发送失败");
        [SVProgressHUD showErrorWithStatus:@"数据发送失败"];
    }
    
    

}

- (IBAction)disConnectAction:(id)sender
{
}

//创建了peripheralManager对象后会自动调用回调方法didUpdateState
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        [self configServiceAndCharacteristicForPeripheral];

    }
}

//给外设配置服务和特征
- (void)configServiceAndCharacteristicForPeripheral {
    
    // 创建服务
    CBUUID *serviceID = [CBUUID UUIDWithString:SERVICE_UUID];
    CBMutableService *service = [[CBMutableService alloc] initWithType:serviceID primary:YES];
    // 创建服务中的特征
    CBUUID *characteristicID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
    CBMutableCharacteristic *characteristic = [
                                               [CBMutableCharacteristic alloc]
                                               initWithType:characteristicID
                                               properties:
                                               CBCharacteristicPropertyRead |
                                               CBCharacteristicPropertyWrite |
                                               CBCharacteristicPropertyNotify
                                               value:nil
                                               permissions:CBAttributePermissionsReadable |
                                               CBAttributePermissionsWriteable
                                               ];
    // 特征添加进服务
    service.characteristics = @[characteristic];
    // 服务加入管理
    [self.peripheralManager addService:service];
    
    // 为了手动给中心设备发送数据
    self.characteristic = characteristic;
}

//调用上面的方法时，会监听didAddService:
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    
}

//调用上 面方法时，会监听DidStartAdvertising:
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    
}

/** 订阅成功回调 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    
//    CBMutableCharacteristic *writeReadCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:@"characteristicUUID"] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadEncryptionRequired | CBAttributePermissionsWriteEncryptionRequired];
    
//    [self.peripheralManager updateValue:UIImagePNGRepresentation(self.imageView.image) forCharacteristic:writeReadCharacteristic onSubscribedCentrals:nil];
}

/** 取消订阅回调 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
}

/** 中心设备读取数据的时候回调 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    
//    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
//        NSData *data = request.characteristic.value;
//        [request setValue:data];
//        [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
//    } else {
//        [self.peripheralManager respondToRequest:request withResult:CBATTErrorReadNotPermitted];
//    }
    
    request.value = UIImagePNGRepresentation(self.imageView.image);
    [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
}

/** 中心设备写入数据的时候回调 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    
//    CBATTRequest *request = [requests lastObject];
//    if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
//        CBMutableCharacteristic *c = (CBMutableCharacteristic *)request.characteristic;
//        c.value = request.value;
//        [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
//    } else {
//        [self.peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
//    }
    
    CBATTRequest *request = requests.lastObject;
    self.imageView.image = [UIImage imageWithData:request.value];

}


@end
