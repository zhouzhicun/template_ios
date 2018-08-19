//
//  AppDelegate.m
//  
//
//  Created by zzc on 2017/11/1.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "AppDelegate.h"


#import "XNLUtils.h"
#import "NEOCrypto.h"
#import "XNLUserManager.h"

#import "XNLGuideViewController.h"

#import "XNLRootWebViewHandler.h"
#import "XNLRootWebViewController.h"
#import "XNLFileBrowserViewController.h"

#import "NEOCrypto.h"



@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) XNLBaseViewController *rootViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    //默认配置 + 第三方SDK配置
    [self defaultConfig];
    [self configSDK];
    
    //启动分发处理
    [self dispatchLaunch];
    return YES;
}


#pragma mark - Private Method

/**
 *  启动分发
 */
- (void)dispatchLaunch
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    if ([[XNLUtils sharedInstance] isFirstRun]) {
//        //第一次运行,进入向导页
//        [self windowRootWithType:XNLWindowRootTypeGuide];
//    } else {
//        //直接进入首页
//        [self windowRootWithType:XNLWindowRootTypeMain];
//    }

    //直接进入首页
    [self windowRootWithType:XNLWindowRootTypeMain];
    [self.window makeKeyAndVisible];
}



- (void)windowRootWithType:(XNLWindowRootType)windowRootType
{
    switch (windowRootType) {
        case XNLWindowRootTypeGuide: {
            //引导页
            self.window.rootViewController = [[XNLGuideViewController alloc] init];
            break;
        }
        case XNLWindowRootTypeMain: {

            NSString *homeUrl = [[XNLUserManager sharedInstance] getServerAddressCache];
  
            NSURL *url = nil;
            if (homeUrl.length > 0) {
                url = [NSURL URLWithString:homeUrl];
            } else {
                url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
            }

            XNLRootWebViewHandler *handler = [[XNLRootWebViewHandler alloc] init];
            
            self.rootViewController =
            [[XNLRootWebViewController alloc] initWithUrl:url handler:handler];
            
            UINavigationController *rootNav =
            [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
            self.window.rootViewController = rootNav;
            break;
        }
    }
}


@end
