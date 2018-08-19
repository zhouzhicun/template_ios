//
//  XNLNetworkConstants.h
//  
//
//  Created by zzc on 2018/6/28.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XNLServerEnvType) {
    
    XNLServerEnvType_Custom = 0,            //自定义环境
    XNLServerEnvType_Develop = 1,           //开发环境
    XNLServerEnvType_Test = 2,              //测试环境
    XNLServerEnvType_PreProduct = 3,        //预发布环境
    XNLServerEnvType_Product = 4,           //生产环境
};


typedef NS_ENUM(NSInteger , XNLRequestMethod) {
    XNLRequestMethodGet = 0,        //Get请求
    XNLRequestMethodPost,           //Post请求
};

typedef NS_ENUM(NSInteger , XNLRequestActionType) {
    XNLRequestTypeActionNormal,           //接口请求业务数据
    XNLRequestTypeActionUpload,           //上传请求
    XNLRequestTypeActionDownload,         //下载请求
};


typedef NS_ENUM(NSUInteger, XNLRequestErrorType) {
    
    XNLRequestErrorTypeNone,            /* 成功 */
    XNLRequestErrorTypeNetwork,         /* 网络错误 */
    XNLRequestErrorTypeServer,          /* 服务器错误(例如404,500等) */
    XNLRequestErrorTypeBusiness,        /* 业务错误 */
    XNLRequestErrorTypeTokenInvalid,    /* token失效 */
};




