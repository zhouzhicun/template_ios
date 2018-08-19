//
//  XNLUtils.m
//  
//
//  Created by chenzhong on 15/3/26.
//  Copyright (c) 2015年 . All rights reserved.
//



#import "XNLUtils.h"

#import <sys/sysctl.h>
#import <SAMKeychain.h>

#import "UIDevice+SSToolkitAdditions.h"

#import "XNLDeviceModel.h"

#import "XNLAppGlobalConfigMacro.h"
#import "NEOCrypto.h"
#import "XNLLocationManager.h"
#import "XNLUserManager.h"


//IDFA
@import AdSupport;





NSString * const kXNLAppUserDefaultCachedKey_Version = @"xnl_ud_app_version";
NSString * const kXNLAppUserDefaultCachedKey_UUID = @"xnl_ud_uuid";

//UUID
NSString * const kXNLAppKeyChainUniqueIdentifier = @"com.ndf.jtoa.uniqueIdentifier";
NSString * const kXNLAppKeyChainUniqueIdentifierValue = @"com.ndf.jtoa.uniqueIdentifierValue";


@interface XNLUtils ()

//网络状态
@property (nonatomic, strong) Reachability *reachability;

//设备
@property (nonatomic, strong) NSMutableDictionary<NSString *, XNLDeviceModel *> *deviceDic;


@property (nonatomic, assign) long long int serverTime;             //服务器时间
@property (nonatomic, assign) NSTimeInterval appStartTime;          //记录服务器获取时间时的启动时间

@end

@implementation XNLUtils


DEF_SINGLETON(XNLUtils)

#pragma mark - Public Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    [self clearServerTime];
    
    NSArray *deviceArr = [XNLDeviceModel deviceModelArr];
    self.deviceDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (XNLDeviceModel *device in deviceArr) {
        [self.deviceDic setObject:device forKey:device.model];
    }
    NSLog(@"deviceDic = %@", self.deviceDic);
}


#pragma mark - 登录态信息

/* UserId */
- (NSString *)getUserId {
    return @"";
}


/* Token */
- (NSString *)getToken {
    return @"";
}

#pragma mark - App版本信息

/* app版本 */
- (NSString *)getAppVersion {
    return kAPPVersion;
}

/* AppCode */
- (NSString *)getAppCode {
    return kAppCode;
}

/* AppType */
- (NSString *)getAppType {
    return @"";
}



/* 缓存当前版本号 */
- (void)cacheCurVersion {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self getAppVersion] forKey:kXNLAppUserDefaultCachedKey_Version];
    [userDefaults synchronize];
}

#pragma mark - App渠道信息

/* 渠道名 */
- (NSString *)getChannelName {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Channel" ofType:@"plist"];
    NSString *channel = @"AppStore";
    if (path) {
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSString *channelString = [tempDictionary objectForKey:@"channel"];
        if (channelString && channelString.length) {
            channel = channelString;
        }
    }
    return channel;
}


/* 渠道ID */
- (NSString *)getChannelId {
    return [self getChannelName];
}



#pragma mark - 第一次运行

/* 是否第一次运行 */
- (BOOL)isFirstRun {
    
    //比较版本号判断是否第一次运行
    NSString *curAppVersion = [self getAppVersion];
    NSString *oldAppVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kXNLAppUserDefaultCachedKey_Version];
    return !oldAppVersion || ![oldAppVersion isEqualToString:curAppVersion];
}


#pragma mark - 网络状态

/* 启动检查网络状态 */
- (void)startCheckNetworkState {
    [self.reachability startNotifier];
}

/* 当前网络状态 */
- (NetworkStatus)curNetworkStatus {
    return [self.reachability currentReachabilityStatus];
}

/* 当前网络状态描述 */
- (NSString *)curNetworkStateName {
    
    NSString *netState = nil;
    switch ([self curNetworkStatus]) {
        case ReachableViaWiFi:
            netState = @"WIFI";
            break;
        case ReachableViaWWAN:
            netState = @"WWAN";
            break;
        case ReachableVia4G:
            netState = @"4G";
            break;
        case ReachableVia3G:
            netState = @"3G";
            break;
        case ReachableVia2G:
            netState = @"2G";
            break;
        case NotReachable:
            netState = @"";
            break;
    }
    return netState;
}



#pragma mark - 系统信息

/* os类型 */
- (NSString *)getOSType {
    return [[UIDevice currentDevice] ss_getOSType];
}

/* os版本 */
- (NSString *)getOSVersion {
    return [[UIDevice currentDevice] ss_getOSVersion];
}

/* 设备类型 */
- (NSString *)getDeviceType {
    return [[UIDevice currentDevice] ss_getDeviceType];
}

/* 分辨率 */
- (NSString *)getDeviceResolution {
    return [[UIDevice currentDevice] ss_getResolution];
}

/* 获取当前设备model */
- (XNLDeviceModel *)getCurDeviceModel {
    NSString *deviceType = [[UIDevice currentDevice] ss_getDeviceType];
    return self.deviceDic[deviceType];
}


/* 经纬度信息 */
- (NSString *)getLocationInfo {
    NSString *location = nil;
    CLLocationCoordinate2D coordinate = [XNLLocationManager sharedInstance].lastCoordinate;
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        location = [NSString stringWithFormat:@"%f,%f",coordinate.latitude, coordinate.longitude];
    }
    return location;
}

/* 经纬度 */
- (CLLocationCoordinate2D )getLocationCoordinate {
    CLLocationCoordinate2D coordinate = [XNLLocationManager sharedInstance].lastCoordinate;
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        coordinate = CLLocationCoordinate2DMake(0.0f, 0.0f);
    }
    return coordinate;
}

/* 设备uuid */
- (NSString *)getUUID {
    
    NSString  *openUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kXNLAppUserDefaultCachedKey_UUID];
    if (openUUID == nil) {

        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * udidStr = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        
        openUUID = [NEOCrypto md5:udidStr];

        NSString *uniqueKeyItem = [SAMKeychain passwordForService:kXNLAppKeyChainUniqueIdentifier account:kXNLAppKeyChainUniqueIdentifierValue];
        if (uniqueKeyItem == nil || [uniqueKeyItem length] == 0) {
            uniqueKeyItem = openUUID;
            [SAMKeychain  setPassword:openUUID forService:kXNLAppKeyChainUniqueIdentifier account:kXNLAppKeyChainUniqueIdentifierValue];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:uniqueKeyItem forKey:kXNLAppUserDefaultCachedKey_UUID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return openUUID;
}


/* 广告IDFA */
- (NSString *)getIDFA {
    
    SEL advertisingIdentifierSel = sel_registerName("advertisingIdentifier");
    SEL UUIDStringSel = sel_registerName("UUIDString");
    
    ASIdentifierManager *manager = [ASIdentifierManager sharedManager];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if([manager respondsToSelector:advertisingIdentifierSel]) {
        
        id UUID = [manager performSelector:advertisingIdentifierSel];
        if([UUID respondsToSelector:UUIDStringSel]) {
            return [UUID performSelector:UUIDStringSel];
        }
    }
#pragma clang diagnostic pop
    return nil;
}



#pragma mark - 服务器时间

/* 获取服务器时间 */
- (NSDate *)getServerTime {
    
    NSTimeInterval time = 0;
    if (self.serverTime == 0) {
        NSDate *date = [NSDate date];
        time = [date timeIntervalSince1970] * 1000;
    } else {
        time = self.serverTime + (long long int)(([self uptime] - self.appStartTime) * 1000);
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(time / 1000.0)];
    return date;
}

- (void)saveServerTime:(long long int)serverTime {
    self.serverTime = serverTime;
    self.appStartTime = [self uptime];
}

- (void)clearServerTime {
    self.serverTime = 0;
    self.appStartTime = 0;
}

- (time_t)uptime {
    
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    
    (void)time(&now);
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = now - boottime.tv_sec;
    }
    return uptime;
}


#pragma mark - Lazy Properties

- (Reachability *)reachability {
    if (!_reachability) {
        _reachability = [Reachability reachabilityForInternetConnection];
    }
    return _reachability;
}



@end
