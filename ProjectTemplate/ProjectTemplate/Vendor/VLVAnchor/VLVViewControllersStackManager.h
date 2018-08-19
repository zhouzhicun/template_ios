//
//  VLVViewControllersStackManager.h
//  VLVCustomViewControllerStackProject
//
//  Created by zzc on 15/8/5.
//  Copyright (c) 2015年 VLV. All rights reserved.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@interface VLVViewControllersStackManager : NSObject
@property (nonatomic, copy, readonly) NSArray *viewControllers;
+ (instancetype)manager;
- (void)pushViewController:(UIViewController *)viewController;
- (UIViewController *)pop;
- (void)clear;
@end
NS_ASSUME_NONNULL_END
