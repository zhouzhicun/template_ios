//
//  XNLHttpManager.m
//  
//
//  Created by zzc on 2018/6/28.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLConnectManager.h"
#import "NSError+XNNetwork.h"

//queueName
const char *kXNLRequestDispatchQueueName = "xnl_http_request_dispatch_queue";


@interface XNLConnectManager ()

/** 环境类型 */
@property (nonatomic, assign) XNLServerEnvType envType;

@end

@implementation XNLConnectManager

DEF_SINGLETON(XNLConnectManager);

//配置环境类型类型以及Https证书
- (void)setupWithEnvType:(XNLServerEnvType)envType {
    self.envType = envType;
}

#pragma mark - HTTP请求

- (void)sendRequest:(XNLBaseRequest *)request
      completeBlock:(XNLRequestCompleteBlock)completeBlock {

    [self sendRequest:request entityClass:nil completeBlock:completeBlock];
}

- (void)sendRequest:(XNLBaseRequest *)request
        entityClass:(Class)entityClass
       completeBlock:(XNLRequestCompleteBlock)completeBlock {

    switch (request.reqMethod) {
        case XNLRequestMethodGet:
        {
            //GET请求
            [self sendGetRequest:request entityClass:entityClass completeBlock:completeBlock];
            break;
        }
        case XNLRequestMethodPost:
        {
            //POST请求
            [self sendPostRequest:request entityClass:entityClass completeBlock:completeBlock];
            break;
        }
        default:
            break;
    }
}



#pragma mark -- Private

//Get方法
- (void)sendGetRequest:(XNLBaseRequest *)request
           entityClass:(Class)entityClass
          completeBlock:(XNLRequestCompleteBlock)completeBlock {
    
    //打印请求
    [request print];
    
    __block XNLBaseResponse *resp = request.response;
    resp.entityClass = entityClass;
    
    AFHTTPSessionManager *manager = request.sessionManager;
    [manager GET:request.url
      parameters:request.reqParamDic
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             //请求成功, data转json字典
             if (responseObject) {
                 id tempResponse =
                 [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject
                                                 options:NSJSONReadingMutableContainers
                                                   error:nil];
                 [resp setReponse:tempResponse error:nil];
             }
             
             if (completeBlock) {
                 completeBlock(resp);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             //请求失败
             [resp setReponse:nil error:error];
             if (completeBlock) {
                 completeBlock(resp);
             }
         }];
    
    
}


//POST方法
- (void)sendPostRequest:(XNLBaseRequest *)request
            entityClass:(Class)entityClass
           completeBlock:(XNLRequestCompleteBlock)completeBlock {
    
    //打印请求
    [request print];

    __block XNLBaseResponse *resp = request.response;
    resp.entityClass = entityClass;
    
    AFHTTPSessionManager *manager = request.sessionManager;
    [manager POST:request.url
       parameters:request.reqParamDic
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              //请求成功, data转json字典
              if (responseObject) {
                  id tempResponse =
                  [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
                  [resp setReponse:tempResponse error:nil];
              }
              
              if (completeBlock) {
                  completeBlock(resp);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              //请求失败
              [resp setReponse:nil error:error];
              if (completeBlock) {
                  completeBlock(resp);
              }
          }];
    
}




#pragma mark - 文件上传下载

//文件上传
- (void)uploadWithRequest:(XNLBaseRequest *)request
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyBlock
            progressBlock:(void (^)(NSProgress *progress))progressBlock
            completeBlock:(XNLRequestCompleteBlock)completeBlock {
    

    __block XNLBaseResponse *resp = request.response;
    resp.entityClass = nil;
    
    [request.sessionManager POST:request.url
                      parameters:request.reqParamDic
       constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
          
          if (constructingBodyBlock) {
              constructingBodyBlock(formData);
          }
      } progress:^(NSProgress * _Nonnull uploadProgress) {
          if (progressBlock) {
              progressBlock(uploadProgress);
          }
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          //请求成功, data转字典
          if (responseObject) {
              id tempResponse =
              [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
              [resp setReponse:tempResponse error:nil];
          }
          
          if (completeBlock) {
              completeBlock(resp);
          }
        
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
          //请求失败
          [resp setReponse:nil error:error];
          if (completeBlock) {
              completeBlock(resp);
          }
          
      }];
    
}

/**
 * 文件下载, 返回有如下情况:
 * 1.error：请求错误
 * 2.文件filePath: 请求成功
 *
 */
- (void)downloadWithRequest:(XNLBaseRequest *)request
              progressBlock:(void (^)(NSProgress *progress))progressBlock
              completeBlock:(XNLDownloadCompleteBlock)completeBlock {
    
    AFHTTPSessionManager *manager = request.sessionManager;
    [[manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request.url]]
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 //进度
                                 CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                                 NSLog(@"progress = %f\n", progress);
                                 if (progressBlock) {
                                     progressBlock(downloadProgress);
                                 }
                             } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                 
                                 //拼接文件路径
                                 NSString *filePath = [[NSFileManager ss_tmpPath] stringByAppendingPathComponent:response.suggestedFilename];
                                 return [NSURL fileURLWithPath:filePath];
                                 
                             } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                 
                                 if (completeBlock) {
                                     completeBlock(filePath, [NSError ss_convertError:error]);
                                 }
      
                             }] resume];
    
}



//#pragma mark - DispatchQueue
//
//- (dispatch_queue_t)requestDispatchQueue {
//    static dispatch_once_t once;
//    static dispatch_queue_t dispatchQueue;
//    dispatch_once( &once, ^{
//        dispatchQueue = dispatch_queue_create(kXNLRequestDispatchQueueName, DISPATCH_QUEUE_CONCURRENT);
//
//    });
//    return dispatchQueue;
//}



@end
