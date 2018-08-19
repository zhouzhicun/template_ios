//
//  XNLServerAddrVM.h
//  
//
//  Created by zzc on 2018/7/3.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLBaseViewModel.h"

@interface XNLServerAddrVM : XNLBaseViewModel

@property (nonatomic, copy) NSString *addr;

- (NSString *)getCurrentAddr;

- (void)cacheAddr;

@end
