//
//  XNLBaseSessionManager.h
//  
//
//  Created by zzc on 16/6/21.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface XNLBaseSessionManager : NSObject

+ (AFHTTPSessionManager *)createCommonSessionManager;

//配置Https证书
+ (void)configSessionManager:(AFHTTPSessionManager *)manager httpsCerName:(NSString *)cerName;

@end
