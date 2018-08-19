//
//  XNLBaseSessionManager.m
//  
//
//  Created by zzc on 16/6/21.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLBaseSessionManager.h"
#import "XNLConnectManager.h"

const char *kXNLRequestCompletionQueueName = "xnl_http_request_completion_queue";


@implementation XNLBaseSessionManager


#pragma mark - Helper

+ (AFHTTPSessionManager *)createCommonSessionManager
{
    //1 初始化manager
    NSURLSessionConfiguration *sessionConfig =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfig];

    manager.completionQueue = dispatch_get_main_queue();
    
    //2 配置responseSerializer
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:responseSerializer.acceptableContentTypes];
    [acceptContentTypes addObjectsFromArray:[self acceptHttpContentTypes]];
    
    responseSerializer.acceptableContentTypes = acceptContentTypes;
    manager.responseSerializer = responseSerializer;
    
    return manager;
}


//配置Https证书
+ (void)configSessionManager:(AFHTTPSessionManager *)manager httpsCerName:(NSString *)cerName {

    if (isEmptyString(cerName)) {
        return;
    }
    
#ifdef DEBUG
    
    // debug模式，可抓包调试
    // 设置非校验证书模式(不校验证书，可以抓包查看, 用于调试)
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;      //客户端是否信任非法证书
    [manager.securityPolicy setValidatesDomainName:NO];         //是否在证书域字段中验证域名
    
#else
    
    
    XNLServerEnvType envType = [XNLConnectManager sharedInstance].envType;
    if (envType == XNLServerEnvType_PreProduct ||
        envType == XNLServerEnvType_Product) {
        
        // 设置校验证书模式(校验证书，不可以抓包, 用于发布和预发布)
        NSString * cerPath = [[NSBundle mainBundle] pathForResource:cerName ofType:@"cer"];
        NSData * cerData   = [NSData dataWithContentsOfFile:cerPath];
        manager.securityPolicy =
        [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate
                         withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
        
        manager.securityPolicy.allowInvalidCertificates = NO;
        [manager.securityPolicy setValidatesDomainName:YES];
        
    } else {
        
        // 开发，测试环境可抓包调试
        // 设置非校验证书模式(不校验证书，可以抓包查看, 用于调试)
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
    }
    
#endif
    
}



+ (NSArray *)acceptHttpContentTypes
{
    return @[@"text/plain",
             @"application/json",
             @"text/json",
             @"application/xml",
             @"text/html",
             @"image/tiff",
             @"image/jpeg",
             @"image/gif",
             @"image/png",
             @"image/ico",
             @"image/x-icon",
             @"image/bmp",
             @"image/x-bmp",
             @"image/x-xbitmap",
             @"image/x-win-bitmap"];
}




@end
