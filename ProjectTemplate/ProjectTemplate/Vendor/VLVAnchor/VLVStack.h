//
//  VLVStack.h
//  VLVCustomViewControllerStackProject
//
//  Created by zzc on 15/8/5.
//  Copyright (c) 2015年 VLV. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN
@interface VLVStack : NSObject
@property (nonatomic, copy, readonly) NSMutableArray *stack;
@property (nonatomic, assign, readonly) NSUInteger count;
- (void)pushObject:(id)object;
- (id)pop;
- (void)clear;
@end
NS_ASSUME_NONNULL_END
