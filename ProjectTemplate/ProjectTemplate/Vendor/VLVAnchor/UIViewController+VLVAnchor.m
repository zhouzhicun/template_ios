//
//  UIViewController+VLVAnchor.m
//  VLVCustomViewControllerStackProject
//
//  Copyright (c) 2015年 VLV. All rights reserved.
//

#import "UIViewController+VLVAnchor.h"
#import <objc/runtime.h>

static void *kUIViewControllerIsNeedSetAnchorPropertyKey = (void *)@"kUIViewControllerIsNeedSetAnchorPropertyKey";
static void *kUIViewControllerPopBackToAnchorBlockKey = (void *)@"kUIViewControllerPopBackToAnchorBlockKey";

@implementation UIViewController (VLVAnchor)
@dynamic isAnchor;
@dynamic popBackToAnchorBlock;

- (BOOL)isAnchor
{
    NSNumber *boolNumber = objc_getAssociatedObject(self, kUIViewControllerIsNeedSetAnchorPropertyKey);
    return [boolNumber boolValue];
}

- (void)setIsAnchor:(BOOL)isAnchor
{
    objc_setAssociatedObject(self, kUIViewControllerIsNeedSetAnchorPropertyKey, @(isAnchor), OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewControllerPopBackToAnchorBlock)popBackToAnchorBlock
{
    return objc_getAssociatedObject(self, kUIViewControllerPopBackToAnchorBlockKey);
}

- (void)setPopBackToAnchorBlock:(UIViewControllerPopBackToAnchorBlock)popBackToAnchorBlock
{
    objc_setAssociatedObject(self, kUIViewControllerPopBackToAnchorBlockKey, popBackToAnchorBlock, OBJC_ASSOCIATION_COPY);
}

@end
