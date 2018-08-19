//
//  NSError+Network.m
//  
//
//  Created by zzc on 2018/7/1.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "NSError+XNNetwork.h"
#import "UIDevice-Reachability.h"

#pragma mark - Http请求错误信息
NSString *const kRequestErrorDomainKey  = @"xnl_http_request_error_domain";
NSString *const kRequestErrorTypeKey    = @"type";
NSString *const kRequestErrorMessageKey = @"message";



@implementation NSError (XNNetwork)


- (NSString *)ss_message
{
    return self.userInfo[kRequestErrorMessageKey];
}

- (XNLRequestErrorType)ss_errorType
{
    return (XNLRequestErrorType)[self.userInfo[kRequestErrorTypeKey] integerValue];
}


//构造Error
+ (NSError *)ss_errorWithCode:(NSInteger)code
                         type:(XNLRequestErrorType)errType
                      message:(NSString *)message {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo ss_setValue:@(errType) forKey:kRequestErrorTypeKey];
    [userInfo ss_setValue:message forKey:kRequestErrorMessageKey];
    return [NSError errorWithDomain:kRequestErrorDomainKey code:code userInfo:userInfo];
}


//转换网络错误
+ (NSError *)ss_convertError:(NSError *)error {
    
    XNLRequestErrorType errType = XNLRequestErrorTypeNone;
    NSString *message = nil;

    if (![error.domain isEqualToString:NSURLErrorDomain]) {
        
        //服务器错误，例如http404，500等
        errType = XNLRequestErrorTypeServer;
        message = @"服务器错误";
        
    } else {
        
        //网络错误
        //网络错误
        errType = XNLRequestErrorTypeNetwork;
        if(![[UIDevice currentDevice] networkAvailable]) {
            //无网络
            message = @"无网络，请检查网络设置";
        } else {
            
            switch (error.code) {
                case NSURLErrorTimedOut: {
                    //连接超时
                    message = @"请求超时，请重试";
                    break;
                }
                default: {
                    //网络连接错误(网络异常)
                    message = @"网络异常，请稍后重试";
                    break;
                }
            }
        }
    }
    
    return [self ss_errorWithCode:error.code type:errType message:message];
}




@end
