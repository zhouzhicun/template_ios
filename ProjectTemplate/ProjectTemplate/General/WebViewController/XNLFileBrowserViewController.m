//
//  XNLFileBrowserViewController.m
//  
//
//  Created by zzc on 2018/6/4.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLFileBrowserViewController.h"
#import "NJKWebViewProgressView.h"


@interface XNLFileBrowserViewController () <WKUIDelegate, WKNavigationDelegate>

//url地址
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@end

@implementation XNLFileBrowserViewController


#pragma mark - Init

- (instancetype)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
        
        //标题取自文件名
        NSArray *arr = [url.absoluteString componentsSeparatedByString:@"/"];
        self.title = [[arr lastObject] ss_urlUTF8Decode];  //url utf8反编码

    }
    return self;
}


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开始加载
    [self loadRequest];
    
}


- (void)dealloc {
    [self clearWebView];
}


#pragma mark - UI

- (void)setupSubView {
    
    self.webView = [self createWebView];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}

- (void)setupConstraint {
    
    @weakify(self)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self.view);
    }];
}

- (void)setupBinding {
    
    
    @weakify(self);
    [RACObserve(self.webView, estimatedProgress) subscribeNext:^(NSNumber *progress) {
        @strongify(self);
        [self.progressView setProgress:progress.floatValue animated:YES];
    }];
}


#pragma mark - WebView

- (WKWebView *)createWebView {
    
    //1 创建UserContentController,并注册handler
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    //2 创建configuration
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    configuration.userContentController = userContentController;
    configuration.preferences = [[WKPreferences alloc] init];
    configuration.preferences.minimumFontSize =10;
    configuration.preferences.javaScriptEnabled =YES;
    configuration.preferences.javaScriptCanOpenWindowsAutomatically =NO;
    
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"]; //禁止长按
    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];   //禁止选择
    WKUserScript *noneSelectScript =
    [[WKUserScript alloc] initWithSource:javascript
                           injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                        forMainFrameOnly:YES];
    
    
    //3 创建webView
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.scrollEnabled = YES;
    [webView.configuration.userContentController addUserScript:noneSelectScript];
    
    
    return webView;
}



- (void)clearWebView {
    
    [self.webView stopLoading];
    self.webView.UIDelegate = nil;
    self.webView.navigationDelegate = nil;
    [self.webView removeFromSuperview];
    
#ifdef DEBUG
    [self clearWebViewCache];
#endif
    
}


- (void)clearWebViewCache {
    
    if (@available(iOS 9.0, *)) {
        
        //        NSArray *arr = @[WKWebsiteDataTypeDiskCache,
        //                         //WKWebsiteDataTypeOfflineWebApplicationCache,
        //                         WKWebsiteDataTypeMemoryCache,
        //                         //WKWebsiteDataTypeCookies,
        //                         //WKWebsiteDataTypeSessionStorage,
        //                         //WKWebsiteDataTypeLocalStorage,
        //                         //WKWebsiteDataTypeWebSQLDatabases,
        //                         //WKWebsiteDataTypeIndexedDBDatabases
        //                         ];
        //        NSSet *types = [NSSet setWithArray:arr];
        
        NSSet *types = [WKWebsiteDataStore allWebsiteDataTypes];   //清除所有缓存
        NSDate *date = [NSDate date];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:date completionHandler:^{
            NSLog(@"clear web cache");
        }];
        
    } else {
        // ios8
        NSString *libPath = [NSFileManager ss_libCachePath];
        NSString *cookiePath = [libPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiePath error:nil];
    }
    
}


- (void)loadRequest {
    
    //debug缓存问题
    [self clearWebViewCache];
    
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:self.url
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:60.0];
    
    [self.webView loadRequest:request];
}


#pragma mark - <WKNavigationDelegate>

//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {

    self.title = @"加载失败";
}


#pragma mark - Property

- (NJKWebViewProgressView *)progressView {
    
    if (!_progressView) {
        CGRect frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 3.0f);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:frame];
        _progressView.progressBarView.backgroundColor = HEXCOLOR(0x506FEE);
    }
    return _progressView;
}

@end
