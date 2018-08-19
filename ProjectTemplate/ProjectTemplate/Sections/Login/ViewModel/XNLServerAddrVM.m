//
//  XNLServerAddrVM.m
//  
//
//  Created by zzc on 2018/7/3.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLServerAddrVM.h"
#import "XNLUserManager.h"

@implementation XNLServerAddrVM

- (void)commonInit {
    [super commonInit];
    self.navBarTitle = @"设置首页地址";
}

- (BOOL)validForm {
    BOOL isValid = NO;
    if (isEmptyString(self.addr)) {
        [self.toastSubject sendNext:@"首页地址不能为空"];
    } else {
        
        NSString *tempAddr = [self.addr ss_trim];
        NSString *first = [tempAddr substringToIndex:1];
        tempAddr = [tempAddr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:first.lowercaseString];
        
        
        if (![tempAddr ss_isURL]) {
            [self.toastSubject sendNext:@"请输入有效的首页地址"];
        } else {
            self.addr = tempAddr;
            isValid = YES;
        }
    }
    return isValid;
}

- (NSString *)getCurrentAddr {
    NSString *addr = [[XNLUserManager sharedInstance] getServerAddressCache];
    if (isEmptyString(addr)) {
        addr = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    }
    return addr;
}

- (void)cacheAddr {
    [[XNLUserManager sharedInstance] cacheServerAddress:self.addr];
}

@end
