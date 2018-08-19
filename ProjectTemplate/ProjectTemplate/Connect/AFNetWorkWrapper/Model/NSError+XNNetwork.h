//
//  NSError+Network.h
//  
//
//  Created by zzc on 2018/7/1.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNLNetworkConstants.h"


@interface NSError (XNNetwork)

- (NSString *)ss_message;

- (XNLRequestErrorType)ss_errorType;

//构造Error
+ (NSError *)ss_errorWithCode:(NSInteger)code
                         type:(XNLRequestErrorType)errType
                      message:(NSString *)message;

//转换网络错误
+ (NSError *)ss_convertError:(NSError *)error;

@end
