//
//  XNLWebFactory.m
//  
//
//  Created by zzc on 2017/11/20.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLWebFactory.h"

#import "XNLRootWebViewHandler.h"
#import "XNLRootWebViewController.h"

@implementation XNLWebFactory





+ (void)redirectURL:(NSString *)urlStr
              curVC:(XNLBaseViewController *)curVC {
    
    if (isEmptyString(urlStr)) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    XNLRootWebViewHandler *handler = [[XNLRootWebViewHandler alloc] init];
    
    XNLRootWebViewController *webVC =
    [[XNLRootWebViewController alloc] initWithUrl:url handler:handler];
    
    webVC.hidesBottomBarWhenPushed = YES;
    [curVC.navigationController pushViewController:webVC animated:YES];
}


+ (void)redirectFileName:(NSString *)fileName
               extension:(NSString *)extension
                   curVC:(XNLBaseViewController *)curVC {
    
    if (isEmptyString(fileName) || isEmptyString(extension)) {
        return;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:extension];
    XNLRootWebViewHandler *handler = [[XNLRootWebViewHandler alloc] init];
    
    XNLRootWebViewController *webVC =
    [[XNLRootWebViewController alloc] initWithUrl:url handler:handler];
    
    webVC.hidesBottomBarWhenPushed = YES;
    [curVC.navigationController pushViewController:webVC animated:YES];
}




@end

