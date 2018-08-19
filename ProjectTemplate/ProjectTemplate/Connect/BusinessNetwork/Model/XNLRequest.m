//
//  XNLRequest.m
//  
//
//  Created by zzc on 2017/11/5.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLRequest.h"

#import "XNLApiConstants.h"
#import "XNLSessionManager.h"

#import "XNLResponse.h"


@implementation XNLRequest


#pragma mark - 请求

+ (XNLRequest *)requestWithApi:(NSString *)api
                       requestParams:(NSDictionary *)reqParamsDic {
    
    return [self requestWithApi:api actionType:XNLRequestTypeActionNormal requestParams:reqParamsDic];
}


+ (XNLRequest *)requestWithApi:(NSString *)api
                          actionType:(XNLRequestActionType)actionType
                       requestParams:(NSDictionary *)reqParamsDic {
    
    NSString *url = getUrlWithApi(api);
    return [self requestWithUrl:url actionType:actionType requestParams:reqParamsDic];
   
}

+ (XNLRequest *)requestWithUrl:(NSString *)url
                          actionType:(XNLRequestActionType)actionType
                       requestParams:(NSDictionary *)reqParamsDic {

    XNLRequest *request =
    [[XNLRequest alloc] initWithMethod:XNLRequestMethodPost
                                  actionType:actionType
                                         url:url
                                 reqParamDic:reqParamsDic];
    
    //设置sessionManager
    switch (actionType) {
        case XNLRequestTypeActionNormal:{
            request.sessionManager = [self httpSessionManger];
            break;
        }
        case XNLRequestTypeActionDownload:{
            request.sessionManager = [self downloadSessionManger];
            break;
        }
        case XNLRequestTypeActionUpload:{
            request.sessionManager = [self uploadSessionManger];
            break;
        }
    }
    
    return request;
}




#pragma mark -- Response

- (XNLBaseResponse *)createRespWithActionType:(XNLRequestActionType)actionType {
    
    XNLResponse *response = [[XNLResponse alloc] init];
    response.actionType = actionType;
    return response;
}


#pragma mark - 请求参数

//业务接口请求
- (NSDictionary *)getHttpReqParamDic:(NSDictionary *)originParamsDic {
    return originParamsDic;
}

//上传请求
- (NSDictionary *)getUploadReqParamDic:(NSDictionary *)originParamsDic {
    return originParamsDic;
}

//下载请求
- (NSDictionary *)getDownloadReqParamDic:(NSDictionary *)originParamsDic {
    return originParamsDic;
}

#pragma mark - SessionManager

+ (AFHTTPSessionManager *)httpSessionManger {
    return [XNLSessionManager defaultSessionManager];
}

+ (AFHTTPSessionManager *)uploadSessionManger {
    return [XNLSessionManager uploadSessionManager];
}

+ (AFHTTPSessionManager *)downloadSessionManger {
    return [XNLSessionManager downloadSessionManager];
}




@end
