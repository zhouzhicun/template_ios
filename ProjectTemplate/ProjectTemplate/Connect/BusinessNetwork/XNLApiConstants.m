//
//  XNLApiConstants.m
//  
//
//  Created by zzc on 2018/6/28.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLApiConstants.h"
#import "XNLConnectManager.h"

#pragma mark - Default BaseURL
#pragma mark -- 开发, 测试, 预发布环境, 生产

NSString *const XNLDefaultServerEnv_Custom      = @"http://www.xxx.com/collection-api/rest";
NSString *const XNLDefaultServerEnv_Develop     = @"http://www.xxx.com/collection-api/rest";
NSString *const XNLDefaultServerEnv_Test        = @"http://www.xxx.com/collection-api/rest";
NSString *const XNLDefaultServerEnv_PreProduct  = @"https://www.xxx.com/collection-api/rest";
NSString *const XNLDefaultServerEnv_Product     = @"https://www.xxx.com/collection-api/rest";


#pragma mark - Method

NSString *defaultBaseURL(void) {
    
    XNLServerEnvType envType = [XNLConnectManager sharedInstance].envType;
    NSString *baseUrl = XNLDefaultServerEnv_Product;    //默认初始化
    switch (envType) {
        case XNLServerEnvType_Custom: {
            baseUrl = XNLDefaultServerEnv_Custom;
            break;
        }
        case XNLServerEnvType_Develop: {
            baseUrl = XNLDefaultServerEnv_Develop;
            break;
        }
        case XNLServerEnvType_Test: {
            baseUrl = XNLDefaultServerEnv_Test;
            break;
        }
        case XNLServerEnvType_PreProduct: {
            baseUrl = XNLDefaultServerEnv_PreProduct;
            break;
        }
        case XNLServerEnvType_Product: {
            baseUrl = XNLDefaultServerEnv_Product;
            break;
        }
    }
    
    return baseUrl;
}

NSString *getUrlWithApi(NSString *api) {
    return [defaultBaseURL() stringByAppendingString:api];
}

