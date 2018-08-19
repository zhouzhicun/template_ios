//
//  XNLUserManager.m
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLUserManager.h"
#import <PINCache/PINCache.h>

#import "XNLApiConstants.h"
#import "XNLGlobalCacheKey.h"


@interface XNLUserManager ()

/* 首页H5页面 */
@property (nonatomic, copy) NSString *curServerAddr;

@end

@implementation XNLUserManager

DEF_SINGLETON(XNLUserManager)


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    //从缓存中读取
    self.curServerAddr = [self getServerAddressCache];
    if (isEmptyString(self.curServerAddr)) {
        self.curServerAddr = @"";
    }
}



#pragma mark - 首页地址

- (void)cacheServerAddress:(NSString *)serverAddr {
    
    self.curServerAddr = serverAddr;
    [[PINCache sharedCache] setObject:self.curServerAddr forKey:kServerAddrCacheKey];
}

- (NSString *)getServerAddressCache {
    return [[PINCache sharedCache] objectForKey:kServerAddrCacheKey];
}

- (void)cleanServerAddressCache {
    self.curServerAddr = nil;
    [[PINCache sharedCache] removeObjectForKey:kServerAddrCacheKey];
}

@end
