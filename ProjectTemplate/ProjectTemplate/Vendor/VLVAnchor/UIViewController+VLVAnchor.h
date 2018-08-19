//
//  UIViewController+VLVAnchor.h
//  VLVCustomViewControllerStackProject
//
//  Copyright (c) 2015年 VLV. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN
typedef void (^UIViewControllerPopBackToAnchorBlock)(void);

@interface UIViewController (VLVAnchor)
@property (nonatomic, assign) BOOL isAnchor;
@property (nonatomic, copy, nullable) UIViewControllerPopBackToAnchorBlock popBackToAnchorBlock;
@end
NS_ASSUME_NONNULL_END
