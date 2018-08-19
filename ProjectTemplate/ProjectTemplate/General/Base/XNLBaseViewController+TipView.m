//
//  XNLBaseViewController+Util.m
//  
//
//  Created by zzc on 16/7/25.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLBaseViewController+TipView.h"
#import "UIView+Toast.h"

#pragma mark - Hud Messages

@implementation XNLBaseViewController (TipView)



#pragma mark -- Hud

- (void)showHud
{
    [self showHudOnSuperView:self.view];
}

- (void)showHudOnSuperView:(UIView *)view
{
    [self showHudOnSuperView:view
                     message:nil
              isNeedAutoHide:NO
          autoHideAfterDelay:0];
    
//    [self showHudOnSuperView:view
//                     hudMode:MBProgressHUDModeCustomView
//                     message:nil
//                  customView:[self loadingImageView]
//              isNeedAutoHide:NO
//          autoHideAfterDelay:0];
    
    

}

- (void)hideHud
{
    [self.hud hideAnimated:YES afterDelay:0];
}




#pragma mark - Toost


- (void)showToastWithText:(NSString *)text
{
    [self showToastWithText:text completion:nil];
}


- (void)showToastWithText:(NSString *)text completion:(void(^)(BOOL didTap))completion
{
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [superView makeToast:text
                duration:1.2
                position:CSToastPositionCenter
                   style:[self createToastStyle]
              completion:completion];
}


#pragma mark - Private



- (CSToastStyle *)createToastStyle {
    
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    
    style.backgroundColor   = HEXACOLOR(0x333333, 0.8f);
    style.maxWidthValue     = kScreenWidth - 40.0f * 2;
    style.cornerRadius      = 5.0;
    style.horizontalPadding = 24.0f;    //左右间距
    style.verticalPadding   = 17.0;     //上下间距
    style.messageColor      = HEXCOLOR(0xffffff);
    style.messageFont       = scaleFontSize(16);
    
    return style;
}


- (UIImageView *)loadingImageView
{
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_%d", i];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:images.firstObject];
    imageView.animationImages = images;
    imageView.animationDuration = 1;
    imageView.animationRepeatCount = INT_MIN;
    [imageView startAnimating];
    return imageView;
}



- (void)showHudOnSuperView:(UIView *)superView
                   message:(NSString *)message
            isNeedAutoHide:(BOOL)isNeedAutoHide
        autoHideAfterDelay:(NSTimeInterval)autoHideAfterDelay {
    
    self.hud.detailsLabel.text = message;
    
    //Show
    if (!self.hud.superview) {
        [superView addSubview:self.hud];
    }
    [self.hud showAnimated:YES];
    
    
    //Is Need Auto Hide
    if (isNeedAutoHide && autoHideAfterDelay > 0.0f) {
        [self.hud hideAnimated:YES afterDelay:autoHideAfterDelay];
    }
}


//
//
//- (void)showHudOnSuperView:(UIView *)superView
//                   hudMode:(MBProgressHUDMode)hudMode
//                   message:(NSString *)message
//                customView:(UIView *)customView
//            isNeedAutoHide:(BOOL)isNeedAutoHide
//        autoHideAfterDelay:(NSTimeInterval)autoHideAfterDelay
//{
//
//    //Reset Content
//    self.hud.mode              = hudMode;
//    self.hud.customView        = customView;
//
//    self.hud.detailsLabel.text = message;
//
//    //Show
//    if (!self.hud.superview) {
//        [superView addSubview:self.hud];
//    }
//    [self.hud showAnimated:YES];
//
//
//    //Is Need Auto Hide
//    if (isNeedAutoHide && autoHideAfterDelay > 0.0f) {
//        [self.hud hideAnimated:YES afterDelay:autoHideAfterDelay];
//    }
//}
//


@end
