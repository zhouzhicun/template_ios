//
//  XNWebViewHandler.m
//  
//
//  Created by zzc on 2018/5/14.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLBaseWebViewHandler.h"

@interface XNLBaseWebViewHandler ()

@property (nonatomic, weak) XNLBaseViewController *curVC;
@property (nonatomic, weak) WKWebView *curWebView;

@end

@implementation XNLBaseWebViewHandler


- (void)setupCurVC:(XNLBaseViewController *)curVC curWebView:(WKWebView *)curWebView {
    self.curVC = curVC;
    self.curWebView = curWebView;
}




#pragma mark - 子类重写

- (void)addMessageHandler:(id<WKScriptMessageHandler>)msgHandler
   userContentController:(WKUserContentController *)contentController {

}

- (void)removeMessageHandlerWithUserContentController:(WKUserContentController *)contentController {
    
}

- (void)dispatchScriptMessage:(WKScriptMessage *)message {
    
}

@end
