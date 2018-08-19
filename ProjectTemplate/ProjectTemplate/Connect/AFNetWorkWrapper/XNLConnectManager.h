//
//  XNLHttpManager.h
//  
//
//  Created by zzc on 2018/6/28.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNLBaseRequest.h"
#import "XNLBaseResponse.h"

/**
 * HTTP请求的完成block定义
 * 对于所有的请求完成回调：
 * 1 首先判断error，判断请求是否出错
 * 2 如果error == nil, 表示请求成功，根据responseDic中的错误码分析请求是否业务成功。
 */
typedef void (^XNLRequestCompleteBlock)(XNLBaseResponse *response);


//下载完成block
typedef void (^XNLDownloadCompleteBlock)(NSURL *filePath, NSError *err);




@interface XNLConnectManager : NSObject

/** 环境类型 */
@property (nonatomic, assign, readonly) XNLServerEnvType envType;

AS_SINGLETON(XNLConnectManager);

//配置环境类型类型以及Https证书
- (void)setupWithEnvType:(XNLServerEnvType)envType;


#pragma mark - HTTP请求

- (void)sendRequest:(XNLBaseRequest *)request
      completeBlock:(XNLRequestCompleteBlock)completeBlock;

- (void)sendRequest:(XNLBaseRequest *)request
        entityClass:(Class)entityClass
      completeBlock:(XNLRequestCompleteBlock)completeBlock;

#pragma mark - 文件上传下载

//文件上传
- (void)uploadWithRequest:(XNLBaseRequest *)request
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyBlock
            progressBlock:(void (^)(NSProgress *progress))progressBlock
            completeBlock:(XNLRequestCompleteBlock)completeBlock;


/**
 * 文件下载, 返回有如下三种情况:
 * 1.error：请求错误
 * 2.文件filePath: 请求成功，文件data保存于respObject
 *
 */
- (void)downloadWithRequest:(XNLBaseRequest *)request
              progressBlock:(void (^)(NSProgress *progress))progressBlock
              completeBlock:(XNLDownloadCompleteBlock)completeBlock;

@end


