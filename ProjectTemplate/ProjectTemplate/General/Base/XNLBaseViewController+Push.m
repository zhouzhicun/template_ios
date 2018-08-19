//
//  XNLBaseViewController+Push.m
//  
//
//  Created by zzc on 16/7/26.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLBaseViewController+Push.h"

@implementation XNLBaseViewController (Push)


#pragma mark - Push & Pop

- (void)pushNormalViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)popToRootAndPushNormalViewController:(UIViewController *)viewController
{
    UIViewController *navigationController = self.navigationController.viewControllers[0];
    [self.navigationController popToRootViewControllerAnimated:NO];
    viewController.hidesBottomBarWhenPushed = YES;
    
    if (viewController) {
        [navigationController.navigationController pushViewController:viewController animated:YES];
    }
}

@end
