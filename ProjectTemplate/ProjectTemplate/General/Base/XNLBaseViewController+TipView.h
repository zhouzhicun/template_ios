//
//  XNLBaseViewController+Util.h
//  
//
//  Created by zzc on 16/7/25.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLBaseViewController.h"

@interface XNLBaseViewController (TipView)


#pragma mark - Hud

- (void)showHud;
- (void)showHudOnSuperView:(UIView *)view;
- (void)hideHud;


#pragma mark - Toost

- (void)showToastWithText:(NSString *)text;

- (void)showToastWithText:(NSString *)text completion:(void(^)(BOOL didTap))completion;

@end
