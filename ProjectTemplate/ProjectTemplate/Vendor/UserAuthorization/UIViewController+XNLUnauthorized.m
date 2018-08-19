//
//  XNLViewController+XNLUnauthorized.m
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "UIViewController+XNLUnauthorized.h"

NSString * const XNLUnauthorizedAlertCancel = @"取消";
NSString * const XNLUnauthorizedAlertConfirm = @"确认";
NSString * const XNLUnauthorizedAlertSetting = @"去设置";

NSString * const XNLUnauthorizedAlert_Location_Title = @"需要访问您当前位置权限";
NSString * const XNLUnauthorizedAlert_Location_Message = @"在“系统设置－隐私－定位服务－%@”中打开";

NSString * const XNLUnauthorizedAlert_AddressBook_Title = @"需要访问您的通讯录权限";
NSString * const XNLUnauthorizedAlert_AddressBook_Message = @"在“手机设置－隐私－通讯录－%@“中打开";

NSString * const XNLUnauthorizedAlert_Photo_Title = @"未启动相机权限";
NSString * const XNLUnauthorizedAlert_Photo_Message = @"在“手机设置-隐私-相机-%@”中打开";

NSString * const XNLUnauthorizedAlert_Camera_Title = @"未启动相机权限";
NSString * const XNLUnauthorizedAlert_Camera_Message = @"在“手机设置-隐私-相机-%@”中打开";

NSString * const XNLUnauthorizedAlert_Micro_Title = @"未启动麦克风权限";
NSString * const XNLUnauthorizedAlert_Micro_Message = @"在“手机设置-隐私-相机-%@”中打开";

//NSString * const XNLUnauthorizedAlert_Location_URLString = @"prefs:root=LOCATION_SERVICES";
//NSString * const XNLUnauthorizedAlert_AddressBook_URLString = @"prefs:root=Privacy&path=CONTACTS";
//NSString * const XNLUnauthorizedAlert_Photo_URLString = @"prefs:root=Privacy&path=CAMERA";
//NSString * const XNLUnauthorizedAlert_Camera_URLString = @"prefs:root=Privacy&path=CAMERA";
//NSString * const XNLUnauthorizedAlert_Micro_URLString = @"prefs:root=Privacy&path=MICROPHONE";

@implementation UIViewController (XNLUnauthorized)

- (void)showUnauthorizedAlertWithCategory:(XNLAuthorizationCategory)authorizedCategory {

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self showAlertWithCategory:authorizedCategory];
    });
    
}

- (void)showCameraUnavailableAlert {

    [self showAlertWithTitle:@"相机不可用"
                     message:nil
           cancelActionTitle:@"确定"
               okActionTitle:nil
                cancelAction:nil
                    okAction:nil];
}

- (void)showVideoUnavailableAlert {
    
    [self showAlertWithTitle:@"拍摄的视频太大或录制时间太短"
                     message:nil
           cancelActionTitle:@"确定"
               okActionTitle:nil
                cancelAction:nil
                    okAction:nil];
    
}


#pragma mark - Private

- (void)showAlertWithCategory:(XNLAuthorizationCategory)authorizedCategory {
    
    NSString *title = nil;
    NSString *message = nil;

    switch (authorizedCategory) {
        case XNLAuthorizationCategoryLocation: {
            title = XNLUnauthorizedAlert_Location_Title;
            message = [NSString stringWithFormat:XNLUnauthorizedAlert_Location_Message, kAPPName];
            break;
        }
        case XNLAuthorizationCategoryAddressBook: {
            title = XNLUnauthorizedAlert_AddressBook_Title;
            message = [NSString stringWithFormat:XNLUnauthorizedAlert_AddressBook_Message, kAPPName];
            break;
        }
        case XNLAuthorizationCategoryPhoto: {
            title = XNLUnauthorizedAlert_Photo_Title;
            message = [NSString stringWithFormat:XNLUnauthorizedAlert_Photo_Message, kAPPName];
            break;
        }
        case XNLAuthorizationCategoryCamera: {
            title = XNLUnauthorizedAlert_Camera_Title;
            message = [NSString stringWithFormat:XNLUnauthorizedAlert_Camera_Message, kAPPName];
            break;
        }
        case XNLAuthorizationCategoryMicro: {
            title = XNLUnauthorizedAlert_Micro_Title;
            message = [NSString stringWithFormat:XNLUnauthorizedAlert_Micro_Message, kAPPName];
            break;
        }
        default:
            break;
    }
    
    NSString *cancelActionTitle  = XNLUnauthorizedAlertCancel;
    NSString *settingActionTitle = XNLUnauthorizedAlertSetting;
    
    [self showAlertWithTitle:title
                     message:message
           cancelActionTitle:cancelActionTitle
               okActionTitle:settingActionTitle
                cancelAction:nil
                    okAction:^(UIAlertAction *action) {
                    
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
    
    
}




#pragma mark - AlertView




@end
