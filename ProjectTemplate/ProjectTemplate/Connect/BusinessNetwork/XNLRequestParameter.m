//
//  XNLRequestParameterConfiguration.m
//  XNLoan
//
//  Created by zzc on 16/7/13.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLRequestParameter.h"

#import "XNLUtils.h"
#import "XNLParamsConstants.h"

@implementation XNLRequestParameter


#pragma mark - Public

+ (NSMutableDictionary *)headerParameters {
    
    XNLUtils *utils = [XNLUtils sharedInstance];
    
    NSMutableDictionary *headParameters = [[NSMutableDictionary alloc] initWithCapacity:0];

    // 自定义头部信息
    [headParameters ss_setObject:[utils getToken]       forKey:kHttpHeaderKey_Token];

    [headParameters ss_setObject:[utils getChannelName] forKey:kHttpHeaderKey_Channel];
    [headParameters ss_setObject:[utils getChannelId]   forKey:kHttpHeaderKey_ChannelId];
    
    [headParameters ss_setObject:[utils getOSType]      forKey:kHttpHeaderKey_OSType];
    [headParameters ss_setObject:[utils getAppCode]  forKey:kHttpHeaderKey_Version];
    
    [headParameters ss_setObject:[utils getUUID]        forKey:kHttpHeaderKey_DeviceId];
    [headParameters ss_setObject:[utils getIDFA]        forKey:kHttpHeaderKey_IDFA];
    [headParameters ss_setObject:[utils getDeviceType]  forKey:kHttpHeaderKey_PhoneType];
    [headParameters ss_setObject:[utils getDeviceResolution] forKey:kHttpHeaderKey_PhoneResolution];
    [headParameters ss_setObject:[utils curNetworkStateName] forKey:kHttpHeaderKey_Network];

    //待定
    [headParameters ss_setObject:[utils getAppCode]     forKey:kHttpHeaderKey_AppCode];
    [headParameters ss_setObject:[utils getAppType]     forKey:kHttpHeaderKey_AppType];
    [headParameters ss_setObject:[utils getLocationInfo] forKey:kHttpHeaderKey_LatitudeLongitude];
  
    
    return headParameters;
}

#pragma mark - Http请求

+ (NSMutableDictionary *)handleParameters:(NSDictionary *)parameters {
    
    NSMutableDictionary *reqParameters = [NSMutableDictionary dictionary];
    //header
    reqParameters[@"header"] = [self headerParameters];
    //body
    reqParameters[@"body"] = parameters;

    return reqParameters;
}

@end
