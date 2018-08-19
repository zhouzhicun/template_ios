//
//  XNLUserManager.h
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNLUserManager : NSObject

AS_SINGLETON(XNLUserManager)

/* 首页H5页面 */
@property (nonatomic, copy, readonly) NSString *curServerAddr;


#pragma mark - 首页地址

- (void)cacheServerAddress:(NSString *)serverAddr;

- (NSString *)getServerAddressCache;

- (void)cleanServerAddressCache;

@end

