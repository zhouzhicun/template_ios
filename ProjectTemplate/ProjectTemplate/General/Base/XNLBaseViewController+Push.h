//
//  XNLBaseViewController+Push.h
//  
//
//  Created by zzc on 16/7/26.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLBaseViewController.h"

@interface XNLBaseViewController (Push)


#pragma mark - 


//Push方法，默认带动画
- (void)pushNormalViewController:(UIViewController *)viewController;

//先Pop到根，再Push方法，默认带动画
- (void)popToRootAndPushNormalViewController:(UIViewController *)viewController;

@end
