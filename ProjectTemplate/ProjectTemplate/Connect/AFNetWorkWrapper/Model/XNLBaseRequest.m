//
//  XNLBaseHttpRequest.m
//  
//
//  Created by zzc on 16/6/20.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLBaseRequest.h"



@interface XNLBaseRequest ()

@property (nonatomic, copy) NSString *url;                            //url
@property (nonatomic, assign) XNLRequestMethod reqMethod;             //请求方法
@property (nonatomic, assign) XNLRequestActionType actionType;        //请求行为类型
@property (nonatomic, copy) NSDictionary *reqParamDic;                //请求参数

@end

@implementation XNLBaseRequest

#pragma mark - init

- (instancetype)initWithMethod:(XNLRequestMethod)reqMethod
                    actionType:(XNLRequestActionType)actionType
                           url:(NSString *)url
                   reqParamDic:(NSDictionary *)originReqParamsDic {
    
    self = [super init];
    if (self != nil) {

        self.reqMethod  = reqMethod;
        self.actionType = actionType;
        self.url        = url;
        
        self.reqParamDic =
        [self reqParamDicWithActionType:actionType originReqParamDic:originReqParamsDic];
        
        //最后设置
        self.response = [self createRespWithActionType:actionType];
    }
    return self;
}


#pragma mark - Public

//请求参数
- (void)print {
    
    NSLog(@"\nbegin request:\n");
    NSLog(@"url = %@\n", self.url);
    NSLog(@"method = %@\n", [self reqMethodDesc]);
    
    if (self.reqParamDic) {
        NSLog(@"params = \n%@\n", self.reqParamDic);
    }
}



#pragma mark - Getter

#pragma mark -- Response

- (XNLBaseResponse *)createRespWithActionType:(XNLRequestActionType)actionType {
    return nil;
}

#pragma mark -- RequestParamDic

//业务接口请求
- (NSDictionary *)getHttpReqParamDic:(NSDictionary *)originParamsDic {
    return nil;
}

//上传请求
- (NSDictionary *)getUploadReqParamDic:(NSDictionary *)originParamsDic {
    return nil;
}

//下载请求
- (NSDictionary *)getDownloadReqParamDic:(NSDictionary *)originParamsDic {
    return nil;
}

#pragma mark -- SessionManager


//业务请求sessionManger
+ (AFHTTPSessionManager *)httpSessionManger {
    return nil;
}

//上传请求sessionManger
+ (AFHTTPSessionManager *)uploadSessionManger {
    return nil;
}

//下载请求sessionManger
+ (AFHTTPSessionManager *)downloadSessionManger {
    return nil;
}


#pragma mark - Private

- (NSDictionary *)reqParamDicWithActionType:(XNLRequestActionType)actionType
                          originReqParamDic:(NSDictionary *)originReqParamDic {
    
    switch (actionType) {
        case XNLRequestTypeActionNormal: {
            
            return [self getHttpReqParamDic:originReqParamDic];
            break;
        }
        case XNLRequestTypeActionUpload: {
            
            return [self getUploadReqParamDic:originReqParamDic];
            break;
        }
        case XNLRequestTypeActionDownload: {
            
            return [self getDownloadReqParamDic:originReqParamDic];
            break;
        }
    }
}

- (NSString *)reqMethodDesc {
    NSString *desc = nil;
    switch (self.reqMethod) {
        case XNLRequestMethodGet: {
            desc = @"GET";
        }
        case XNLRequestMethodPost: {
            desc = @"POST";
        }
    }
    return desc;
}


@end
