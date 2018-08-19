//
//  XNLSessionManager.m
//  
//
//  Created by zzc on 2018/7/1.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLSessionManager.h"

NSString *const kHttpHeaderKey_UserAgent         = @"User-Agent";
NSString *const kHttpHeaderKey_Charset           = @"Charset";
NSString *const kHttpHeaderKey_ContentType       = @"Content-Type";
NSString *const kHttpHeaderKey_ContentEncoding   = @"Content-Encoding";
NSString *const kHttpHeaderKey_AcceptEncoding    = @"Accept-Encoding";


NSString *const kHttpsCerName = @"https";



@implementation XNLSessionManager


+ (AFHTTPSessionManager *)defaultSessionManager {
    
    static dispatch_once_t once;
    static AFHTTPSessionManager *manager;
    dispatch_once( &once, ^{
        
        manager = [self createCommonSessionManager];
        [self configSessionManager:manager httpsCerName:kHttpsCerName];
        
        // 配置requestSerializer
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"jtoa-%@",kAPPVersion]
                         forHTTPHeaderField:kHttpHeaderKey_UserAgent];
        
        [manager.requestSerializer setValue:@"UTF-8"
                         forHTTPHeaderField:kHttpHeaderKey_Charset];
        
        [manager.requestSerializer setValue:@"application/json"
                         forHTTPHeaderField:kHttpHeaderKey_ContentType];
        
        [manager.requestSerializer setValue:@"gzip"
                         forHTTPHeaderField:kHttpHeaderKey_AcceptEncoding];
        
        manager.requestSerializer.timeoutInterval = 20.0f;
        
        
        
    });
    
    return manager;
}


+ (AFHTTPSessionManager *)uploadSessionManager {
    
    static dispatch_once_t uploadOnce;
    static AFHTTPSessionManager *uploadManager;
    dispatch_once( &uploadOnce, ^{
        
        uploadManager = [self createCommonSessionManager];
        [self configSessionManager:uploadManager httpsCerName:kHttpsCerName];
        
        
        // 配置requestSerializer
        uploadManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [uploadManager.requestSerializer setValue:@"UTF-8"
                               forHTTPHeaderField:kHttpHeaderKey_Charset];
        
        [uploadManager.requestSerializer setValue:@"multipart/form-data"
                               forHTTPHeaderField:kHttpHeaderKey_ContentType];
        
        //        [uploadManager.requestSerializer setValue:@"gzip"
        //                         forHTTPHeaderField:kHttpHeaderKey_AcceptEncoding];
        
        uploadManager.requestSerializer.timeoutInterval = 60.0f;
        
    });
    
    return uploadManager;
}

+ (AFHTTPSessionManager *)downloadSessionManager {
    
    static dispatch_once_t downloadOnce;
    static AFHTTPSessionManager *downloandManager;
    dispatch_once( &downloadOnce, ^{
        
        downloandManager = [self createCommonSessionManager];
        [self configSessionManager:downloandManager httpsCerName:kHttpsCerName];
        
        downloandManager.requestSerializer.timeoutInterval = 60.0f;
        
    });
    
    return downloandManager;
}


@end
