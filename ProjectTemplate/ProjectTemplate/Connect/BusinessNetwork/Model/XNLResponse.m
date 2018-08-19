//
//  XNLHttpResponse.m
//  
//
//  Created by zzc on 2018/6/28.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLResponse.h"

//response字段
NSString *const kXNLRespCodeKey       = @"code";
NSString *const kXNLRespDataKey       = @"data";
NSString *const kXNLRespMessageKey    = @"msg";
NSString *const kXNLRespServerTimeKey = @"serverTime";

//response错误码值
NSString *const kXNLRequestCode_Success         = @"0";              //业务正常
NSString *const kXNLRequestCode_InvildToken     = @"990113";         //token失效

@implementation XNLResponse




//解析Response数据
- (RACTuple *)convertResponse:(NSDictionary *)response {
    
    NSDictionary *responseDic = response;

    //默认初始化
    XNLRequestErrorType errType = XNLRequestErrorTypeNone;
    NSString *message = nil;
    NSString *code = kXNLRequestCode_Success;
    
    //1 无数据, 认为服务器错误, 并返回
    if (responseDic.count == 0) {
        
        errType = XNLRequestErrorTypeServer;
        message = @"服务器错误";
        NSError *err = [NSError ss_errorWithCode:code.integerValue type:errType message:message];
        
        return RACTuplePack(nil, err);
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
        
        NSError *err = [NSError ss_errorWithCode:code.integerValue type:errType message:message];
        return RACTuplePack(nil, err);
        
    } else {

        //业务成功
        id data = responseDic[kXNLRespDataKey];
        if (self.entityClass) {
            
            //解析data为entity对象
            SEL methodSEL = NSSelectorFromString(@"parserEntityWithDictionary:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            id obj = nil;
            if ([self.entityClass respondsToSelector:methodSEL]) {
                obj = [self.entityClass performSelector:methodSEL withObject:data];
            } else {
                obj = nil;
            }
            return RACTuplePack(obj, nil);
            
#pragma clang diagnostic pop
            
        } else {
            return RACTuplePack(data, nil);
        }
    }
    
    
    
    

}

@end
