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
@property (strong, nonatomic) CBCharacteristic *Characteristic;
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(SearchBarBtnClicked)];
    
}

-(void)SearchBarBtnClicked
{
    //1.创建中央管理者
    self.centralMgr  = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey : [NSNumber numberWithBool:YES]}];
    
    
}

#pragma mark - CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            //2.扫描周边设备
            //Services:服务的UUID，不传则搜索全部
            
        [self.centralMgr scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:@{
                                                                          CBCentralManagerScanOptionAllowDuplicatesKey : [NSNumber numberWithBool:NO]
                                                                          }];

            break;
            
        default:
            break;
    }
}

//发现外围设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //3.记录扫描到的设备
    
    if ([peripheral.name hasPrefix:@"h"]|| [peripheral.identifier.UUIDString isEqualToString:SERVICE_UUID] || [peripheral.identifier.UUIDString isEqualToString:CHARACTERISTIC_UUID])
    {
        [SVProgressHUD showSuccessWithStatus:@"发现设备"];
        self.peripheral = peripheral;
    }
    
    
}
#pragma mark - 连接设备
- (IBAction)connecct:(id)sender
{
    //4.连接扫描到的设备
    [self.centralMgr connectPeripheral:_peripheral options:nil];
}

#pragma mark - 连接到外设
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //5.扫描服务：UUID，传空扫描所有服务
    [peripheral discoverServices:nil];
    NSLog(@"连接成功");
    
    //6.设置外设代理
    peripheral.delegate = self;

    [SVProgressHUD showSuccessWithStatus:@"连接成功"];
    
    //停止扫描
    [self.centralMgr stopScan];
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接外设失败%@",error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
//    NSLog(@"断开连接");
//    //断开后，重新连接
//    [central connectPeripheral:peripheral options:nil];

    NSString *str = [NSString stringWithFormat:@"已断开与设备:%@的连接",peripheral.name];
    [SVProgressHUD showErrorWithStatus:str];

}


#pragma mark - 外设代理 -发现服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //7.获取指定的服务，然后根据此服务来查找特征
    
    if (error)
    {
        NSLog(@"扫描外设服务出错：%@-> %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    
//    NSLog(@"扫描到外设服务：%@ -> %@",peripheral.name,peripheral.services);
    for (CBService *service in peripheral.services) {
        
        if ([service.UUID.UUIDString isEqualToString:SERVICE_UUID])
        {
            //如果UUID一致，则开始扫描特征
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHARACTERISTIC_UUID]] forService:service];
        }
    }
}

#pragma mark - 外设代理 -发现特征
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error
{
    if (error)
    {
        NSLog(@"扫描外设的特征失败！%@->%@-> %@",peripheral.name,service.UUID, [error localizedDescription]);
        return;
    }
    
   //8.获取指定特征
    NSLog(@"扫描到外设服务特征有：%@->%@->%@",peripheral.name,service.UUID,service.characteristics);

    for (CBCharacteristic *characte in service.characteristics) {
        if ([characte.UUID.UUIDString isEqualToString:CHARACTERISTIC_UUID]) {
           
            // 这里只获取一个特征，写入数据的时候需要用到这个特征
            self.Characteristic = characte;
            
            //直接读取这个特征数据，会调用didUpdateValueForCharacteristic
            [peripheral readValueForCharacteristic:characte];
            
            // [peripheral writeValue:nil forCharacteristic:characte type:CBCharacteristicWriteWithResponse];
         
            // 订阅通知
            [peripheral setNotifyValue:YES forCharacteristic:characte];
            
        }
    }
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"订阅失败");
        NSLog(@"%@",error);
    }
    
    if (characteristic.isNotifying) {
        if (characteristic.properties==CBCharacteristicPropertyNotify) {
            NSLog(@"已订阅特征通知.");
            return;
        }else if (characteristic.properties ==CBCharacteristicPropertyRead) {
            //从外围设备读取新值,调用此方法会触发代理方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
            [peripheral readValueForCharacteristic:characteristic];
        }
        
    }else{
        
        NSLog(@"取消订阅");

    }
    
}

/** 接收到数据回调 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"扫描外设的特征失败！%@-> %@",peripheral.name, [error localizedDescription]);
        return;
    }
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CHARACTERISTIC_UUID]])
    {
        NSData *data = characteristic.value;
        NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        if (value.length) {
            [SVProgressHUD showSuccessWithStatus:value];

        }
        
//        self.imageView.image = [UIImage imageWithData:data];
    }
}


//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {

        NSString *errorStr = [NSString stringWithFormat:@"发送数据失败:%@",error.userInfo[@"NSLocalizedDescription"]];
        [SVProgressHUD showErrorWithStatus:errorStr];

    }else{
    
        [SVProgressHUD showSuccessWithStatus:@"发送数据成功"];
    }
    
    [peripheral readValueForCharacteristic:characteristic];
}

#pragma mark - 发送数据
- (IBAction)sendAction:(id)sender
{
    NSData *data = [@"蓝牙数据" dataUsingEncoding:NSUTF8StringEncoding];
    //    NSData *data = UIImagePNGRepresentation(self.imageView.image);
    
    [self.peripheral writeValue:data forCharacteristic:self.Characteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark - 断开连接
- (IBAction)disConnect:(id)sender
{
    [self.centralMgr cancelPeripheralConnection:self.peripheral];
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

@end
