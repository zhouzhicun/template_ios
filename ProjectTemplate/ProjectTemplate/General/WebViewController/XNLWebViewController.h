//
//  XNLWebViewController.h
//  
//
//  Copyright (c) 2015年 . All rights reserved.
//

#import "XNLBaseViewController.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebsiteDataStore.h>
#import <WebKit/WKWebsiteDataRecord.h>

#import "XNLBaseWebViewHandler.h"


//    //方式1：加载服务器上html
//    NSString *servAddr = [XNLUserManager sharedInstance].curServerAddr;
//    self.rootViewController =
//    [[XNLWebViewController alloc] initWithUrl:[NSURL URLWithString:servAddr]];

//    //方式2：加载本地html文件
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
//    self.rootViewController =
//    [[XNLWebViewController alloc] initWithUrl:url];


@interface XNLWebViewController : XNLBaseViewController

@property (nonatomic, strong, readonly) WKWebView *webView;

- (instancetype)initWithUrl:(NSURL *)url handler:(XNLBaseWebViewHandler *)handler;

@end

