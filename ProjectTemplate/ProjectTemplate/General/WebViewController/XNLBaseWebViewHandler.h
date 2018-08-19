//
//  XNWebViewHandler.h
//  
//
//  Created by zzc on 2018/5/14.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <WebKit/WKWebsiteDataStore.h>
#import <WebKit/WKWebsiteDataRecord.h>

#import "XNLBaseViewController.h"

@interface XNLBaseWebViewHandler : NSObject

@property (nonatomic, weak, readonly) XNLBaseViewController *curVC;
@property (nonatomic, weak, readonly) WKWebView *curWebView;

- (void)setupCurVC:(XNLBaseViewController *)curVC curWebView:(WKWebView *)curWebView;

//添加handler
- (void)addMessageHandler:(id<WKScriptMessageHandler>)msgHandler
    userContentController:(WKUserContentController *)contentController;

//移除handler
- (void)removeMessageHandlerWithUserContentController:(WKUserContentController *)contentController;

//分发处理
- (void)dispatchScriptMessage:(WKScriptMessage *)message;

@end
