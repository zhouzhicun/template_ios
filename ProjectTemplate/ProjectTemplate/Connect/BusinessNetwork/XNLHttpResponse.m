//
//  XNLHttpResponse.m
//  XNHuicui
//
//  Created by xiaoniu on 2018/6/28.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "XNLHCTempResponse.h"
#import "UIDevice-Reachability.h"

//response字段
NSString *const kXNLRespCodeKey       = @"code";
NSString *const kXNLRespDataKey       = @"data";
NSString *const kXNLRespMessageKey    = @"msg";
NSString *const kXNLRespServerTimeKey = @"serverTime";

//response错误码值
NSString *const kXNLRequestCode_Success         = @"0";              //业务正常
NSString *const kXNLRequestCode_InvildToken     = @"990113";         //token失效

@implementation XNLHCTempResponse

- (void)preHandle {
    if (self.originError) {
        [self handleNetworkError];
    } else {
        [self handleResponse];
    }
}

- (void)handleResponse {
    
    if (self.actionType == XNLRequestTypeActionDownload) {
        //下载文件，直接取respObject即可
        return;
    } else {
        //其他方式
        [self parseResponse];
    }
}



//解析Response数据
- (void)parseResponse {
    
    NSDictionary *responseDic = self.originRespDic;

    //默认初始化
    XNLRequestErrorType errType = XNLRequestErrorTypeNone;
    NSString *message = nil;
    NSString *code = kXNLRequestCode_Success;
    
    //1 无数据, 认为服务器错误, 并返回
    if (responseDic.count == 0) {
        
        errType = XNLRequestErrorTypeServer;
        message = @"服务器错误";
        self.errType = errType;
        self.originError = [self errorWithType:errType code:code.integerValue message:message];
        return;
    }
    
    //1 错误信息
    message = responseDic[kXNLRespMessageKey];
    
    //2 解析code错误码: 兼容字符串和整数
    id codeValue = responseDic[kXNLRespCodeKey];
    if ([codeValue isKindOfClass:[NSString class]]) {
        code = (NSString *)codeValue;
    } else if ([codeValue isKindOfClass:[NSNumber class]]) {
        code = [(NSNumber *)codeValue stringValue];
    }
    
    //3.错误码处理
    if (![code isEqualToString:kXNLRequestCode_Success]) {
        
        //业务错误, 并继续判断是否Token失效
        errType = XNLRequestErrorTypeBusiness;
        if ([code isEqualToString:kXNLRequestCode_InvildToken]) {
            errType = XNLRequestErrorTypeTokenInvalid;
        }
        self.errType = errType;
        self.originError = [self errorWithType:errType code:code.integerValue message:message];
        
    } else {

        //业务成功
        self.errType = XNLRequestErrorTypeNone;
        
        id data = responseDic[kXNLRespDataKey];
        if (self.actionType == XNLRequestTypeActionFetchFile) {
            //接口请求文件
            self.respObject = data;
        } else {
            
            //业务接口或者上传文件
            if (self.entityClass) {
                
                //解析data为entity对象
                SEL methodSEL = NSSelectorFromString(@"parserEntityWithDictionary:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if ([self.entityClass respondsToSelector:methodSEL]) {
                    self.respObject = [self.entityClass performSelector:methodSEL withObject:data];
                } else {
                    self.respObject = nil;
                }
#pragma clang diagnostic pop
                
            } else {
                self.respObject = data;
            }
        }
        
        

    }
    
    
    
    

}




//处理网络错误
- (void)handleNetworkError {
    
    XNLRequestErrorType errType = XNLRequestErrorTypeNone;
    NSString *message = nil;
    
    NSError *error = self.originError;
    if (![error.domain isEqualToString:NSURLErrorDomain]) {
        
        //服务器错误，例如http404，500等
        errType = XNLRequestErrorTypeServer;
        message = @"服务器错误";
        
    } else {
        
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
    
    self.originError = [self errorWithType:errType code:error.code message:message];
}

@end
