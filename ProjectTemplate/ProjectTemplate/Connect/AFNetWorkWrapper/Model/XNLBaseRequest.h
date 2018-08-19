//
//  XNLBaseHttpRequest.h
//  
//
//  Created by zzc on 16/6/20.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFHTTPSessionManager.h>
#import "XNLNetworkConstants.h"
#import "XNLBaseResponse.h"


@interface XNLBaseRequest : NSObject

@property (nonatomic, copy, readonly) NSString *url;                            //url
@property (nonatomic, assign, readonly) XNLRequestMethod reqMethod;             //请求方法
@property (nonatomic, assign, readonly) XNLRequestActionType actionType;        //请求行为类型
@property (nonatomic, copy, readonly) NSDictionary *reqParamDic;                //请求参数


@property (nonatomic, strong) XNLBaseResponse *response;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

#pragma mark - init

- (instancetype)initWithMethod:(XNLRequestMethod)reqMethod
                    actionType:(XNLRequestActionType)actionType
                           url:(NSString *)url
                   reqParamDic:(NSDictionary *)originReqParamsDic;


//请求参数
- (void)print;





#pragma mark - Getter

#pragma mark -- Response

- (XNLBaseResponse *)createRespWithActionType:(XNLRequestActionType)actionType;


#pragma mark -- RequestParamDic

//业务接口请求
- (NSDictionary *)getHttpReqParamDic:(NSDictionary *)originParamsDic;

//上传请求
- (NSDictionary *)getUploadReqParamDic:(NSDictionary *)originParamsDic;

//下载请求
- (NSDictionary *)getDownloadReqParamDic:(NSDictionary *)originParamsDic;


#pragma mark -- SessionManager

//业务请求sessionManger
+ (AFHTTPSessionManager *)httpSessionManger;

//上传请求sessionManger
+ (AFHTTPSessionManager *)uploadSessionManger;

//下载请求sessionManger
+ (AFHTTPSessionManager *)downloadSessionManger;





@end




