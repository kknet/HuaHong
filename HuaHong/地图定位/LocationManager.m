//
//  LocationManager.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/23.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "LocationManager.h"
#import "AppDelegate.h"
@interface LocationManager ()
{
    CLLocationManager *locationManager;
}

@end
@implementation LocationManager

+(instancetype)sharedLocationManager
{
    static LocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil){
            manager = [[LocationManager alloc]init];
        }
    });
    
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        locationManager = [[CLLocationManager alloc]init];
        
        //如果没有授权则请求授权
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        {
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];

            }
            
        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdelegate.isStartLocation = YES;
            [self startLocation];
        }
        
    }
    
    return self;
}
- (BOOL)isEnableLocation
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    }
    
    return NO;
}

- (void)startLocation
{
    locationManager.delegate = self;
    //请设置定位精度
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位频率，每隔多少米定位1次
//    CLLocationDistance distance = 10.0;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [self startUpdatingLocation];
}

- (void)startUpdatingLocation
{
    [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [locationManager stopUpdatingLocation];
}


#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    _latitude = coordinate.latitude;
    _longitude = coordinate.longitude;
    _timestamp = [location timestamp];
    
    
//    NSLog(@"latitude:%f",_latitude);
//    NSLog(@"longitude:%f",_longitude);
//    NSLog(@"course:%f",location.course);
//    NSLog(@"speed:%f",location.speed);
//    NSLog(@"floor:%@",location.floor);
//    NSLog(@"altitude:%f",location.altitude);

    /*
    double distance = 0.0;
    CLLocation *location1 = [[CLLocation alloc]initWithLatitude:32.185438 longitude:122.449361];
    distance = [location distanceFromLocation:location1];
   */

    //反地理编码
    CLGeocoder *reverseGeoCode = [[CLGeocoder alloc]init];
    [reverseGeoCode reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && placemarks.count > 0)
        {
            NSDictionary *dic = [[placemarks firstObject] addressDictionary];
            NSString *City = [dic objectForKey:@"City"];
            NSString *SubLocality = [dic objectForKey:@"SubLocality"];
            NSString *Street = [dic objectForKey:@"Street"];
            _address = [NSString stringWithFormat:@"%@%@%@",City,SubLocality,Street];
            
//            NSLog(@"Name:%@",[dic objectForKey:@"Name"]);
//            NSLog(@"address:%@",_address);
//            NSLog(@"jsonStr:%@",[Utils convertToJsonFrom:dic]);
        }else
        {
//            NSLog(@"反地理编码失败");
        }
    }];
    
    
    //地理编码
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder geocodeAddressString:@"顾村公园" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count == 0 || error) {
//            NSLog(@"地理编码失败");
            return ;
        }
        
        for (CLPlacemark *placemark in placemarks) {
//            double latitude = placemark.location.coordinate.latitude;
//            double longitude = placemark.location.coordinate.longitude;
//            NSString *city = placemark.locality;
//            NSString *detaildress = placemark.name;

        }
        
    }];
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.latitude = _latitude;
    appdelegate.longitude = _longitude;
    appdelegate.address = _address;
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败!");
}
@end
