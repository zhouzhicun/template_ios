//
//  VLVViewControllersStackManager.m
//  VLVCustomViewControllerStackProject
//
//  Created by zzc on 15/8/5.
//  Copyright (c) 2015年 VLV. All rights reserved.
//

#import "VLVViewControllersStackManager.h"
#import "VLVStack.h"

@interface VLVViewControllersStackManager ()
@property (nonatomic, strong) VLVStack *viewControllersStack;
@end
@implementation VLVViewControllersStackManager

#pragma mark - Life Cycle
- (void)dealloc
{
    
}

#pragma mark -- Initializer Methods
+ (instancetype)manager
{
    static VLVViewControllersStackManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VLVViewControllersStackManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewControllersStack = [[VLVStack alloc] init];
    }
    return self;
}

#pragma mark - Public Methods
- (void)pushViewController:(UIViewController *)viewController
{
    [_viewControllersStack pushObject:viewController];
    NSLog(@"\nStack: %@", [VLVViewControllersStackManager manager].viewControllers);
}

- (UIViewController *)pop
{
    UIViewController *viewController = [_viewControllersStack pop];
    NSLog(@"\nStack: %@", [VLVViewControllersStackManager manager].viewControllers);
    return viewController;
}

- (void)clear
{
    [_viewControllersStack clear];
    NSLog(@"\nStack: %@", [VLVViewControllersStackManager manager].viewControllers);
}

#pragma mark - Accessors
- (NSArray *)viewControllers
{
    return _viewControllersStack.stack;
}

@end
