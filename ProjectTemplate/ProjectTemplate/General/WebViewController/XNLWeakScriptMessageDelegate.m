//
//  XNLWeakScriptMessageDelegate.m
//  
//
//  Created by zzc on 2017/11/5.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLWeakScriptMessageDelegate.h"

@interface XNLWeakScriptMessageDelegate ()

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

@end

@implementation XNLWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
