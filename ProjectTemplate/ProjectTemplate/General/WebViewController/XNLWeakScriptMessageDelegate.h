//
//  XNLWeakScriptMessageDelegate.h
//  
//
//  Created by zzc on 2017/11/5.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKScriptMessageHandler.h>

@interface XNLWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
