//
//  XNLLocationManager.m
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLLocationManager.h"
#import <CoreLocation/CoreLocation.h>

#import "UIViewController+XNLUnauthorized.h"
#import "WGS84ConvertToGCJ02.h"


/*
 * CLGeocoder[reverseGeocodeLocation: completionHandler:] 反编码位置信息报错 error = 2 的原因有以下几种：
 * 1. 1分钟之内多次调用接口. 应改成尽量少调用反编码接口。
 * 2. 手机有设置代理， 应关闭手机网络代理。
 * 3. App是否有关闭网络权限，如果有关闭网络权限，开启VPN下可反编码成功， 没开VPN下反编码失败。
 *
 */


@interface XNLLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D lastCoordinate;

@property (nonatomic, strong) CLGeocoder *clGeoCoder;

@property (nonatomic, copy) XNLLocationCompleteBlock completeBlock;

@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *subLocality;
@property (nonatomic, copy) NSString *street;

@property (nonatomic, assign) BOOL singleLocation;  //单次定位
@property (nonatomic, assign) BOOL hasLocation;     //已定位
@end

@implementation XNLLocationManager

DEF_SINGLETON(XNLLocationManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lastCoordinate = kCLLocationCoordinate2DInvalid;
        
    }
    return self;
}


- (void)location {
    [self.locationManager requestWhenInUseAuthorization];
}


- (BOOL)canUseLocationWithAuthType:(XNLLocationAuthorizationType)authType {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (authType) {
        case XNLLocationAuthorizationTypeWhenUse: {
            //使用时定位
            if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
                return YES;
            }
            break;
        }
        case XNLLocationAuthorizationTypeAlways: {
            //一直定位
            if (status == kCLAuthorizationStatusAuthorizedAlways) {
                return YES;
            }
            break;
        }
    }
    //其余返回NO
    return NO;
}


- (void)startSingleLocationCompleteBlock:(XNLLocationCompleteBlock)completeBlock {
    
    [self setupManagerWithSingleLocation:YES hasLocation:NO];
    
    self.completeBlock = completeBlock;
    if ([self canUseLocationWithAuthType:XNLLocationAuthorizationTypeWhenUse]) {
        [self startUpdatingLocation];
    }
}

- (void)startLocationWhenUse:(XNLLocationCompleteBlock)completeBlock {
    
    [self setupManagerWithSingleLocation:NO hasLocation:NO];
    self.completeBlock = completeBlock;
    if ([self canUseLocationWithAuthType:XNLLocationAuthorizationTypeWhenUse]) {
        [self startUpdatingLocation];
    }
}

- (void)startLocationAlways:(XNLLocationCompleteBlock)completeBlock {
    
    [self setupManagerWithSingleLocation:NO hasLocation:NO];
    self.completeBlock = completeBlock;
    if ([self canUseLocationWithAuthType:XNLLocationAuthorizationTypeAlways]) {
        [self startUpdatingLocation];
    }
}

#pragma mark - Private

- (void)setupManagerWithSingleLocation:(BOOL)singleLocation hasLocation:(BOOL)hasLocation {
    self.singleLocation = singleLocation;
    self.hasLocation = hasLocation;
}

- (void)startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}

- (void)setAddress:(NSDictionary *)dict {
    self.state          = [dict objectForKey:@"State"];
    self.city           = [dict objectForKey:@"City"];
    self.subLocality    = [dict objectForKey:@"SubLocality"];
    self.street         = [dict objectForKey:@"Street"];
    self.street         = [dict objectForKey:@"Street"];
}

- (void)reverseAddressDetailWithLocation:(CLLocation *)location {
    @weakify(self)
    [self.clGeoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * placemarks, NSError * error) {
        @strongify(self)
        if (placemarks.count) {
            CLPlacemark *placemark = [placemarks ss_objectAtIndex:0];
            [self setAddress:placemark.addressDictionary];
        } else {
            NSLog(@"无法反编定位信息！Error:%@", error);
        }
    }];
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if ([self canUseLocationWithAuthType:XNLLocationAuthorizationTypeWhenUse]) {
        [self startLocationWhenUse:nil];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    if (locations.count == 0 || self.hasLocation) {
        return;
    }
    
    CLLocation *location = locations[0];
    if (!CLLocationCoordinate2DIsValid(location.coordinate) ||
        [WGS84ConvertToGCJ02 isLocationOutOfChina:[location coordinate]]) {
        //无效或者国外经纬度
        return;
    }
    
    //WGS84 -> GCJ02
    CLLocationCoordinate2D coord = [WGS84ConvertToGCJ02 transformFromWGSToGCJ:[location coordinate]];
    location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    //保存当前位置信息
    self.lastCoordinate = location.coordinate;
    self.hasLocation = YES;
    
    //反编码
    [self reverseAddressDetailWithLocation:location];

    if (self.completeBlock) {
        self.completeBlock(location, nil);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hasLocation = NO;
    });
    
    if (self.singleLocation) {
        [self stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.completeBlock) {
        self.completeBlock(nil, error);
    }
}







#pragma mark - Property

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 100;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

- (CLGeocoder *)clGeoCoder {
    if (!_clGeoCoder) {
        _clGeoCoder = [[CLGeocoder alloc] init];
    }
    return _clGeoCoder;
}

@end
