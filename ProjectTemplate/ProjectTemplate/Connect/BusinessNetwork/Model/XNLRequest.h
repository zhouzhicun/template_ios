//
//  XNLRequest.h
//  
//
//  Created by zzc on 2017/11/5.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLBaseRequest.h"
#import "XNLApiConstants.h"

@interface XNLRequest : XNLBaseRequest

#pragma mark - 请求

//默认业务接口请求
+ (XNLRequest *)requestWithApi:(NSString *)api
                       requestParams:(NSDictionary *)reqParamsDic;

+ (XNLRequest *)requestWithApi:(NSString *)api
                          actionType:(XNLRequestActionType)actionType
                       requestParams:(NSDictionary *)reqParamsDic;

+ (XNLRequest *)requestWithUrl:(NSString *)url
                          actionType:(XNLRequestActionType)actionType
                       requestParams:(NSDictionary *)reqParamsDic;

@end
