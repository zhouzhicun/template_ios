//
//  XNLViewController+XNLUnauthorized.h
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLViewController.h"

#pragma mark - Enum

typedef NS_ENUM(NSUInteger, XNLAuthorizationCategory) {
    
    /** 定位授权 */
    XNLAuthorizationCategoryLocation = 0,
    
    /** 联系人授权 */
    XNLAuthorizationCategoryAddressBook,
    
    /** 相册授权 */
    XNLAuthorizationCategoryPhoto,
    
    /** 相机授权 */
    XNLAuthorizationCategoryCamera,
    
    /** 麦克风授权 */
    XNLAuthorizationCategoryMicro,
};


@interface UIViewController (XNLUnauthorized)

- (void)showUnauthorizedAlertWithCategory:(XNLAuthorizationCategory)authorizedCategory;

//相机不可用
- (void)showCameraUnavailableAlert;

//视频不可用
- (void)showVideoUnavailableAlert;

@end
