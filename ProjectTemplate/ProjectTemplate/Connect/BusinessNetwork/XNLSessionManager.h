//
//  XNLSessionManager.h
//  
//
//  Created by zzc on 2018/7/1.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNLBaseSessionManager.h"

@interface XNLSessionManager : XNLBaseSessionManager


+ (AFHTTPSessionManager *)defaultSessionManager;

+ (AFHTTPSessionManager *)uploadSessionManager;

+ (AFHTTPSessionManager *)downloadSessionManager;

@end
