//
//  BlueToothController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/8.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "BlueToothController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID @"68753A44-4D6F-1226-9C60-0050E4C00067"
#define CHARACTERISTIC_UUID @"68753A44-4D6F-1226-9C60-0050E4C00067"

@interface BlueToothController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CBCentralManager *centralMgr;
@property (strong, nonatomic) NSMutableArray *peripheralArr;
@property (strong, nonatomic) CBPeripheral *peripheral;
@end

@implementation BlueToothController
-(NSMutableArray *)peripheralArr
{
    if (_peripheralArr == nil) {
        _peripheralArr = [NSMutableArray array];
    }
    
    return _peripheralArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建中央管理者
    self.centralMgr = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    
}

#pragma mark - CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            //2.扫描周边设备
            //Services:服务的UUID，不传则搜索全部
//            [self.centralMgr scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            
    [self.centralMgr scanForPeripheralsWithServices:nil options:nil];

            break;
            
        default:
            break;
    }
}

//发现外围设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //3.记录扫描到的设备
    if (![self.peripheralArr containsObject:peripheral]) {
        [self.peripheralArr addObject:peripheral];
    }
    
    self.peripheral = peripheral;
    
    //断开连接
    [self.centralMgr stopScan];
}
#pragma mark - 连接设备
- (IBAction)connecct:(id)sender
{
    //4.连接扫描到的设备
//    CBPeripheral *peripheral = [self.peripheralArr lastObject];
    [self.centralMgr connectPeripheral:_peripheral options:nil];
    
    //5.设置外设代理
    _peripheral.delegate = self;
    
    
}

#pragma mark - 连接到外设
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //6.扫描服务：UUID，传空扫描所有服务
    [peripheral discoverServices:nil];
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"已断开与设备:%@的连接",peripheral.name);
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark - 外设代理 -发现服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //7.获取指定的服务，然后根据此服务来查找特征
    for (CBService *service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:SERVICE_UUID]) {
            //如果UUID一致，则开始扫描特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

#pragma mark - 外设代理 -发现特征
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error
{
   //8.获取指定特征
    for (CBCharacteristic *characte in service.characteristics) {
        if ([characte.UUID.UUIDString isEqualToString:CHARACTERISTIC_UUID]) {
            
            //读写操作
//            [peripheral readValueForCharacteristic:characte];
//            [peripheral writeValue:nil forCharacteristic:characte type:CBCharacteristicWriteWithResponse];
        }
    }
}

//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CHARACTERISTIC_UUID]])
    {
        NSData *data = characteristic.value;
        self.imageView.image = [UIImage imageWithData:data];
    }
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else {
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralMgr cancelPeripheralConnection:self.peripheral];
    }
}

//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
    }
    
    [peripheral readValueForCharacteristic:characteristic];
}

#pragma mark - 选择图片
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

#pragma mark - 发送数据
- (IBAction)sendAction:(id)sender
{
    
}

#pragma mark - 断开连接
- (IBAction)disConnect:(id)sender
{
    [self.centralMgr stopScan];
}

@end
