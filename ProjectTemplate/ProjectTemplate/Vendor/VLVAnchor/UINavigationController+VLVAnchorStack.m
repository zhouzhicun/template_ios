//
//  UINavigationController+VLVAnchorStack.m
//  VLVCustomViewControllerStackProject
//
//  Copyright (c) 2015年 VLV. All rights reserved.
//

#import "UINavigationController+VLVAnchorStack.h"
#import <objc/runtime.h>
#import "VLVViewControllersStackManager.h"

@implementation UINavigationController (VLVAnchorStack)

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        swizzleMethod([self class], @selector(pushViewController:animated:), @selector(anchorPushViewController:animated:));
        swizzleMethod([self class], @selector(popViewControllerAnimated:), @selector(anchorPopViewControllerAnimated:));
        swizzleMethod([self class], @selector(popToRootViewControllerAnimated:), @selector(anchorPopToRootViewControllerAnimated:));
    });
}

- (void)anchorPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    for (NSUInteger i = 0; i < self.viewControllers.count; i++) {
        
        if ([self.viewControllers[i] isMemberOfClass:[viewController class]]
            && ((UIViewController *)self.viewControllers[i]).isAnchor) {
            
            NSArray *popedArray = [self popToViewController:self.viewControllers[i] animated:YES];
            for (UIViewController *popController in popedArray) {
                if (popController.isAnchor) {
                    popController.isAnchor = NO;
                    [[VLVViewControllersStackManager manager] pop];
                }
            }
            UIViewController *currentViewController = self.topViewController;
            if (currentViewController.isAnchor) {
                currentViewController.isAnchor = NO;
                [[VLVViewControllersStackManager manager] pop];
                if (currentViewController.popBackToAnchorBlock) {
                    currentViewController.popBackToAnchorBlock();
                }
            }
            return;
        }
    }
    
    UIViewController *currentViewController = self.topViewController;
    if (currentViewController.isAnchor) {
        [[VLVViewControllersStackManager manager] pushViewController:currentViewController];
    }
    
    [self anchorPushViewController:viewController animated:animated];
}

- (UIViewController *)anchorPopViewControllerAnimated:(BOOL)animated
{
    UIViewController *popedViewController = [self anchorPopViewControllerAnimated:animated];
    UIViewController *currentViewController = self.topViewController;
    
    NSArray *stackViewControllers = [VLVViewControllersStackManager manager].viewControllers;
    if ([stackViewControllers containsObject:currentViewController]) {
        currentViewController.isAnchor = NO;
        
        [[VLVViewControllersStackManager manager] pop];
        if (currentViewController.popBackToAnchorBlock) {
            currentViewController.popBackToAnchorBlock();
        }
    }
    
    return popedViewController;
}

- (NSArray *)anchorPopToRootViewControllerAnimated:(BOOL)animated
{
    [[VLVViewControllersStackManager manager] clear];
    return [self anchorPopToRootViewControllerAnimated:animated];
}


- (NSArray *)popToAnchorViewControllerAnimated:(BOOL)animated
{
    NSArray *stackViewControllers = [VLVViewControllersStackManager manager].viewControllers;
    UIViewController *destinationViewController = stackViewControllers.lastObject;
    
    if ([self.viewControllers containsObject:destinationViewController]) {
        UIViewController *currentViewController = self.topViewController;
        if ([currentViewController isEqual:destinationViewController]) {
            return [self popToRootViewControllerAnimated:animated];
        } else {
            destinationViewController.isAnchor = NO;
            [[VLVViewControllersStackManager manager] pop];
            if (destinationViewController.popBackToAnchorBlock) {
                destinationViewController.popBackToAnchorBlock();
            }
            return [self popToViewController:destinationViewController animated:animated];
        }
    } else {
        return [self popToRootViewControllerAnimated:animated];
    }
}

- (void)forcePushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self anchorPushViewController:viewController animated:animated];
}

@end
