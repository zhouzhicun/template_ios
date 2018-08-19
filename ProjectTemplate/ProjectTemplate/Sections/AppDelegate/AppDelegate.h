//
//  AppDelegate.h
//  
//
//  Created by zzc on 2017/11/1.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XNLWindowRootType) {
    XNLWindowRootTypeGuide,         /* 引导页 */
    XNLWindowRootTypeMain,          /* App主页 */
};




@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)windowRootWithType:(XNLWindowRootType)windowRootType;

@end

#import "AppDelegate+SDK.h"
