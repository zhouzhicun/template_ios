//
//  XNLLocationManager+BaiduSDK.m
//  
//
//  Created by zzc on 2018/7/3.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLBaiduLocationManager.h"
#import "XNLThirdPartSDKConfigMacro.h"

@interface XNLBaiduLocationManager ()

@property (nonatomic, strong) BMKLocationManager *locationManager;

@property (nonatomic, strong) BMKLocation *curLocation;   //当前位置信息

@property(nonatomic, copy) BMKLocatingCompletionBlock completionBlock;

@end

@implementation XNLBaiduLocationManager

DEF_SINGLETON(XNLBaiduLocationManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initBlock];
    }
    return self;
}


- (void)checkPermision {
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BMLocation_APPKEY authDelegate:self];
}


- (void)location {
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:self.completionBlock];
}


-(void)initBlock
{
    
    @weakify(self);
    self.completionBlock = ^(BMKLocation *location, BMKLocationNetworkState state, NSError *error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        
        NSLog(@"netstate = %d",state);
        
        @strongify(self);
        self.curLocation = location;
    };
}


#pragma mark - BMKLocationAuthDelegate

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    
    if (iError == BMKLocationAuthErrorSuccess) {
        //成功
        [self location];
    }
}


#pragma mark - BMKLocationManagerDelegate

/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    
}


/**
 *  @brief 连续定位回调函数。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param location 定位结果，参考BMKLocation。
 *  @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error {
    
}

/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 BMKLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}


/**
 * @brief 该方法为BMKLocationManager提示需要设备校正回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例。
 */
- (BOOL)BMKLocationManagerShouldDisplayHeadingCalibration:(BMKLocationManager * _Nonnull)manager {
    return YES;
}

/**
 * @brief 该方法为BMKLocationManager提供设备朝向的回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 * @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
          didUpdateHeading:(CLHeading * _Nullable)heading {
    
}

/**
 * @brief 该方法为BMKLocationManager所在App系统网络状态改变的回调事件。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 * @param state 当前网络状态
 * @param error 错误信息
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
     didUpdateNetworkState:(BMKLocationNetworkState)state orError:(NSError * _Nullable)error {
    
}




#pragma mark - Property

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        _locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}



@end
