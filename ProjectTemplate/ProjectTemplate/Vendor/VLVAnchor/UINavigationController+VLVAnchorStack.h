//
//  UINavigationController+VLVAnchorStack.h
//  VLVCustomViewControllerStackProject
//
//  Copyright (c) 2015年 VLV. All rights reserved.
//

@import UIKit;

#import "UIViewController+VLVAnchor.h"

NS_ASSUME_NONNULL_BEGIN
@interface UINavigationController (VLVAnchorStack)
- (NSArray *)popToAnchorViewControllerAnimated:(BOOL)animated;
- (void)forcePushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
NS_ASSUME_NONNULL_END
