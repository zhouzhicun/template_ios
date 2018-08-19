//
//  VLVStack.m
//  VLVCustomViewControllerStackProject
//
//  Created by zzc on 15/8/5.
//  Copyright (c) 2015年 VLV. All rights reserved.
//

#import "VLVStack.h"

@interface VLVStack ()
@property (nonatomic, copy) NSMutableArray *stack;
@property (nonatomic, assign) NSUInteger count;
@end
@implementation VLVStack

#pragma mark - Life Cycle
- (void)dealloc
{
    
}

#pragma mark -- Initializer Methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        _stack = [[NSMutableArray alloc] init];
        _count = 0;
    }
    return self;
}

#pragma mark - Public Methods
- (void)pushObject:(id)object
{
    NSLog(@"Push Stack");
    [_stack addObject:object];
    self.count = _stack.count;
}

- (id)pop
{
    NSLog(@"Pop Stack");
    id object = nil;
    if (_stack.count) {
        object = _stack.lastObject;
        [_stack removeLastObject];
        self.count = _stack.count;
    }
    return object;
}

- (void)clear
{
    NSLog(@"Clear Stack");
    [_stack removeAllObjects];
    self.count = 0;
}

@end
