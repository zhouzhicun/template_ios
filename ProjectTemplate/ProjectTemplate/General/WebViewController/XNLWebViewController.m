//
//  XNLWebViewController.m
//  
//
//  Copyright (c) 2015年 . All rights reserved.
//

#import "XNLWebViewController.h"

#import "XNLCommonButton.h"
#import "NJKWebViewProgressView.h"
#import "XNLWeakScriptMessageDelegate.h"

#import "XNLBaseWebViewHandler.h"


typedef NS_ENUM(NSUInteger, XNLWebViewLoadStatus) {
    XNLWebViewLoadStatus_Loading,       //加载中
    XNLWebViewLoadStatus_Success,       //加载成功
    XNLWebViewLoadStatus_Failed,        //加载失败
};

//导航栏Title
NSString *const kXNLWebViewNavigationLoadingTitle       = @"正在加载…";
NSString *const kXNLWebViewNavigationLoadFailedTitle    = @"加载失败";



#ifdef DEBUG

@interface NSURLRequest(ForSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;

@end

@implementation NSURLRequest(ForSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host
{
    
}

@end

#endif

@interface XNLWebViewController ()
<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

//url地址
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

//当前加载状态
@property (nonatomic, assign) XNLWebViewLoadStatus curLoadStatus;

//当前处理器
@property (nonatomic, strong) XNLBaseWebViewHandler *curHandler;

@end

@implementation XNLWebViewController


#pragma mark - Init

- (instancetype)initWithUrl:(NSURL *)url handler:(XNLBaseWebViewHandler *)handler {
    self = [super init];
    if (self) {
        self.url = url;
        
        self.curLoadStatus = XNLWebViewLoadStatus_Loading;
        self.curHandler = handler;
    }
    return self;
}


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    //开始加载
    self.title = kXNLWebViewNavigationLoadingTitle;
    [self loadRequest];
}


- (void)dealloc {
    [self clearWebView];
}



#pragma mark - UI

- (void)setupSubView {
    
    self.webView = [self createWebView];
    [self.curHandler setupCurVC:self curWebView:self.webView];
    
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
    
    [super setupBinding];
    
    @weakify(self);
    [RACObserve(self.webView, title) subscribeNext:^(NSString *title) {
        @strongify(self);
        self.title = title;
    }];

    [RACObserve(self.webView, estimatedProgress) subscribeNext:^(NSNumber *progress) {
        @strongify(self);
        [self.progressView setProgress:progress.floatValue animated:YES];
    }];
}

#pragma mark -

- (void)backButtonPressed:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}



#pragma mark - WebView

- (WKWebView *)createWebView {
    
    //1 创建UserContentController,并注册handler
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    XNLWeakScriptMessageDelegate *msgHandler = [[XNLWeakScriptMessageDelegate alloc] initWithDelegate:self];
    [self.curHandler addMessageHandler:msgHandler userContentController:userContentController];

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
    
    WKUserContentController *contentController = [[self.webView configuration] userContentController];
    [self.curHandler removeMessageHandlerWithUserContentController:contentController];

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
    self.curLoadStatus = XNLWebViewLoadStatus_Loading;
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.curLoadStatus = XNLWebViewLoadStatus_Success;
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    self.curLoadStatus = XNLWebViewLoadStatus_Failed;
    self.title = kXNLWebViewNavigationLoadFailedTitle;
}

////接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//    
//}
//
////在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    
//    
//    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationResponsePolicyCancel);
//}
//


//在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //拨打电话
    NSURL *URL = navigationAction.request.URL;
    if ([[URL scheme] isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
    }
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);

}
//
//#pragma mark - <WKUIDelegate>
//
////创建一个新的WebView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//    
//    return [[WKWebView alloc]init];
//}
//
////输入框
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
//    
//    completionHandler(@"http");
//}
//
//
////确认框
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
//    completionHandler(YES);
//}
//
////警告框
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    
//    NSLog(@"%@",message);
//    completionHandler();
//}


#pragma mark - <WKScriptMessageHandler>

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    //由handler处理
    [self.curHandler dispatchScriptMessage:message];
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
