//
//  XNLUtils.h
//  
//
//  Created by chenzhong on 15/3/26.
//  Copyright (c) 2015年 . All rights reserved.
//

//Vendors
#import "Reachability.h"
#import "XNLDeviceModel.h"

@interface XNLUtils : NSObject

AS_SINGLETON(XNLUtils)

#pragma mark - 登录态信息

/* UserId */
- (NSString *)getUserId;

/* Token */
- (NSString *)getToken;

#pragma mark - App版本信息

/* app版本 */
- (NSString *)getAppVersion;

/* AppCode */
- (NSString *)getAppCode;

/* AppType */
- (NSString *)getAppType;

/* 缓存当前版本号 */
- (void)cacheCurVersion;


#pragma mark - App渠道信息

/* 渠道名 */
- (NSString *)getChannelName;

/* 渠道ID */
- (NSString *)getChannelId;

#pragma mark - 第一次运行

/* 是否第一次运行 */
- (BOOL)isFirstRun;

#pragma mark - 网络状态

/* 启动检查网络状态 */
- (void)startCheckNetworkState;

/* 当前网络状态 */
- (NetworkStatus)curNetworkStatus;

/* 当前网络状态描述 */
- (NSString *)curNetworkStateName;

#pragma mark - 系统信息

/* os类型 */
- (NSString *)getOSType;

/* os版本 */
- (NSString *)getOSVersion;

/* 设备类型 */
- (NSString *)getDeviceType;

/* 分辨率 */
- (NSString *)getDeviceResolution;

/* 获取当前设备model */
- (XNLDeviceModel *)getCurDeviceModel;

/* 经纬度信息 */
- (NSString *)getLocationInfo;

/* 经纬度 */
- (CLLocationCoordinate2D )getLocationCoordinate;

/* 设备uuid */
- (NSString *)getUUID;

/* 广告IDFA */
- (NSString *)getIDFA;


#pragma mark - 服务器时间

/* 获取服务器时间 */
- (NSDate *)getServerTime;

- (void)saveServerTime:(long long int)serverTime;

@end

