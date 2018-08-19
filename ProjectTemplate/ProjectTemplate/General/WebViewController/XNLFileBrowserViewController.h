//
//  XNLFileBrowserViewController.h
//  
//
//  Created by zzc on 2018/6/4.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLBaseViewController.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebsiteDataStore.h>
#import <WebKit/WKWebsiteDataRecord.h>

/**
 * XNLWebViewController简化版，只用于预览本地文件, 无js交互
 */

// eg:
//    [NSFileManager ss_copyFile:@"测试文档.doc"
//                        atPath:[[NSBundle mainBundle] resourcePath]
//                    toDestFile:@"hello.doc"
//                    atDestPath:[NSFileManager ss_tmpPath]
//                         Error:nil];
//
//    NSString *destPath = [NSString stringWithFormat:@"%@/%@", [NSFileManager ss_tmpPath], @"hello.doc"];
//    NSURL *url = [NSURL fileURLWithPath:destPath];

//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"测试文档"  withExtension:@"doc"];
//    XNLFileBrowserViewController *browserVC =
//    [[XNLFileBrowserViewController alloc] initWithUrl:url];
//    [self.curWebVC pushNormalViewController:browserVC];



@interface XNLFileBrowserViewController : XNLBaseViewController

- (instancetype)initWithUrl:(NSURL *)url;

@end
