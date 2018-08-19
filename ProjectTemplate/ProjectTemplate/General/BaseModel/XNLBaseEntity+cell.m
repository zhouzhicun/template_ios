//
//  XNLBaseEntity+cell.m
//  
//
//  Created by zzc on 2018/7/23.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLBaseEntity+cell.h"

@implementation XNLBaseEntity (cell)

- (void)setCellHeight:(NSNumber *)cellHeight {
    
    [self willChangeValueForKey:@"cellHeight"];
    objc_setAssociatedObject(self, _cmd, cellHeight, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"cellHeight"];
}

- (NSNumber *)cellHeight {
    return objc_getAssociatedObject(self, @selector(setCellHeight:));
}

@end
