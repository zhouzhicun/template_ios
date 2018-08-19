//
//  XNLRootWebViewHandler.m
//  
//
//  Created by zzc on 2018/7/2.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLRootWebViewHandler.h"

#import "XNLAppGlobalConfigMacro.h"

#import "XNLWebConstants.h"
#import "XNLUtils.h"


#import "XNLUserManager.h"
#import "XNLDataStatisticsManager.h"
#import "XNLVideoRecordManager.h"
#import "XNLImageManager.h"
#import "XNLBaiduLocationManager.h"
#import "XNLAddressBookManager.h"
#import "UIViewController+XNLUnauthorized.h"


#import "XNLRequest.h"
#import "XNLConnectManager.h"

#import "XNQRCodeScanViewController.h"
#import "XNLFileBrowserViewController.h"





//H5原生路由方法
NSString *const kXNJSNativeMethodName_Dispatch = @"dispatch";

//js<->native
NSString *const kXNDispatchParamsKey_MethodName = @"func";
NSString *const kXNDispatchParamsKey_CallBackName = @"callback";
NSString *const kXNDispatchParamsKey_Data = @"data";

//原生方法
NSString *const kXNJSNativeMethodName_Login = @"login";                         //登陆
NSString *const kXNJSNativeMethodName_LoginResult = @"loginResult";             //登陆结果

NSString *const kXNJSNativeMethodName_Call = @"call";                           //拨打电话
NSString *const kXNJSNativeMethodName_GetLocation = @"getLocation";             //定位信息
NSString *const kXNJSNativeMethodName_Scan = @"scan";                           //二维码扫描

NSString *const kXNJSNativeMethodName_GetAllContacts = @"getAllContacts";       //所有联系人
NSString *const kXNJSNativeMethodName_PickerContact = @"pickerContact";         //选择联系人

NSString *const kXNJSNativeMethodName_TakePhoto = @"takePhoto";                 //拍照
NSString *const kXNJSNativeMethodName_PickerPhoto = @"pickerPhoto";             //选择照片

NSString *const kXNJSNativeMethodName_ShowLoading = @"showLoading";             //等待框
NSString *const kXNJSNativeMethodName_ShowToast = @"showToast";                 //Toast提示


NSString *const kXNJSNativeMethodName_CacheData = @"cacheData";                 //缓存数据
NSString *const kXNJSNativeMethodName_GetCacheData = @"getCacheData";           //获取缓存数据

NSString *const kXNJSNativeMethodName_BrowserFile = @"browserFile";             //预览文件
NSString *const kXNJSNativeMethodName_ReportEvent = @"reportEvent";             //上报事件

NSString *const kXNJSNativeMethodName_GetUserInfo = @"getUserInfo";             //获取用户信息
NSString *const kXNJSNativeMethodName_GetDeviceInfo = @"getDeviceInfo";         //获取设备信息

NSString *const kXNJSNativeMethodName_RecordVideo = @"recordVideo";             //录制视频
NSString *const kXNJSNativeMethodName_ReloadUrlSuffix = @"reloadUrlSuffix";     //重定向指定URL

NSString *const kXNJSNativeMethodName_Share = @"share";                         //分享


@interface XNLRootWebViewHandler ()

@property (nonatomic, copy) NSString *callback;

@end

@implementation XNLRootWebViewHandler

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self addNotify];
    }
    return self;
}


- (void)addNotify {

    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kXNNotifyName_QRCodeScanResult object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         
         //二维码扫描
         @strongify(self);
         [self evaluateJSWithFunc:self.callback
                         callBack:nil
                          dataDic:notification.userInfo
                completionHandler:nil];
     }];
}


#pragma mark - Handler Register

//添加handler
- (void)addMessageHandler:(id<WKScriptMessageHandler>)msgHandler
    userContentController:(WKUserContentController *)contentController {

    [contentController addScriptMessageHandler:msgHandler name:kXNJSNativeMethodName_Dispatch];
}

//移除handler
- (void)removeMessageHandlerWithUserContentController:(WKUserContentController *)contentController {
    
    [contentController removeScriptMessageHandlerForName:kXNJSNativeMethodName_Dispatch];
}

//分发处理
- (void)dispatchScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"msg.name = %@", message.name);
    NSLog(@"msg.body = %@", message.body);
    
    NSString *func          = message.body[kXNDispatchParamsKey_MethodName];
    NSString *callBack      = message.body[kXNDispatchParamsKey_CallBackName];
    NSDictionary *dataDic   = message.body[kXNDispatchParamsKey_Data];
    
    if ([func isEqualToString:kXNJSNativeMethodName_Login]) {
        
        //登陆
        [self loginWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_LoginResult]) {
        
        //登陆结果
        [self loginResultWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_Call]) {
        
        //拨打电话
        [self callWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_GetLocation]) {
        
        //定位信息
        [self getLocationWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_Scan]) {
        
        //二维码扫描
        [self scanWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_GetAllContacts]) {
        
        //所有联系人
        [self getAllContactsWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_PickerContact]) {
        
        //选择单个联系人
        [self pickerContactWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_TakePhoto]) {
        
        //拍照
        [self takePhotoWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_PickerPhoto]) {
        
        //选择照片
        [self pickerPhotoWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_ShowLoading]) {
        
        //等待框
        [self showLoadingWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_ShowToast]) {
        
        //toast提示
        [self showToastWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_CacheData]) {
        
        //缓存数据
        [self cacheDataWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_GetCacheData]) {
        
        //获取缓存数据
        [self getCacheDataWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_BrowserFile]) {
        
        //预览文件
        [self browserFileWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_ReportEvent]) {
        
        //上报友盟埋点
        [self reportEventWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_GetUserInfo]) {
        
        //获取用户信息
        [self getUserInfoWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_GetDeviceInfo]) {
        
        //设备信息
        [self getDeviceInfoWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_RecordVideo]) {
        
        //录制视频
        [self recordVideoWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_ReloadUrlSuffix]) {
        
        //返回：重定向指定URL
        [self goToBackForwardWithCallBack:callBack dataDic:dataDic];
        
    } else if ([func isEqualToString:kXNJSNativeMethodName_Share]) {
        
        //分享
        [self shareWithCallBack:callBack dataDic:dataDic];
    }
}




- (void)evaluateJSWithFunc:(NSString *)func
                  callBack:(NSString *)callback
                   dataDic:(NSDictionary *)dataDic
         completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic ss_setObject:func forKey:kXNDispatchParamsKey_MethodName];
    [dic ss_setObject:dataDic forKey:kXNDispatchParamsKey_Data];
    
    NSString *dataJson = [dic ss_jsonString];
    NSString *js = [NSString stringWithFormat:@"%@(%@)", kXNJSNativeMethodName_Dispatch, dataJson];
    [self.curWebView evaluateJavaScript:js completionHandler:completionHandler];
}




#pragma mark - NativeMethod

- (void)loginWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
}


- (void)loginResultWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
}


- (void)callWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //拨打电话
    NSString *tel = dataDic[@"phone"];
    NSURL *telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:telUrl options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:telUrl];
    }
    

//    [self.curVC showAlertWithTitle:nil
//                              message:tel
//                    cancelActionTitle:@"取消"
//                        okActionTitle:@"呼叫"
//                         cancelAction:nil
//                             okAction:^(UIAlertAction *action) {
//                                 if (@available(iOS 10.0, *)) {
//                                     [[UIApplication sharedApplication] openURL:telUrl options:@{} completionHandler:nil];
//                                 } else {
//                                     [[UIApplication sharedApplication] openURL:telUrl];
//                                 }
//                             }];
}


- (void)getLocationWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //位置信息
    BMKLocation *location = [XNLBaiduLocationManager sharedInstance].curLocation;
    
    NSMutableDictionary *resultDic = nil;
    if (location) {
        CLLocationCoordinate2D coordinate = location.location.coordinate;
        BMKLocationReGeocode *rgcData = location.rgcData;
        
        resultDic = [NSMutableDictionary dictionary];
        [resultDic ss_setObject:@(coordinate.latitude) forKey:@"Latitude"];
        [resultDic ss_setObject:@(coordinate.longitude) forKey:@"Longitude"];
        [resultDic ss_setObject:rgcData.province forKey:@"Province"];
        [resultDic ss_setObject:rgcData.city forKey:@"City"];
        [resultDic ss_setObject:rgcData.district forKey:@"District"];
        [resultDic ss_setObject:rgcData.street forKey:@"Street"];
        [resultDic ss_setObject:rgcData.streetNumber forKey:@"StreetNumber"];
    }
    
    [self evaluateJSWithFunc:callBack
                    callBack:nil
                     dataDic:resultDic
           completionHandler:nil];
}


- (void)scanWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    self.callback = callBack;
    XNQRCodeScanViewController *vc = [[XNQRCodeScanViewController alloc] init];
    [self.curVC pushNormalViewController:vc];
}

- (void)getAllContactsWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //所有联系人
    @weakify(self);
    XNLAddressBookManager *manager = [XNLAddressBookManager sharedInstance];
    [manager getContactListWithViewController:nil
                                completeBlock:^(NSArray *contactList) {
                                    
                                    @strongify(self);
                                    
                                    NSMutableDictionary *resultDic = nil;
                                    if (contactList.count > 0) {
                                        resultDic = [NSMutableDictionary dictionary];
                                        [resultDic ss_setObject:contactList forKey:@"list"];
                                    }

                                    [self evaluateJSWithFunc:callBack
                                                    callBack:nil
                                                     dataDic:resultDic
                                           completionHandler:nil];
                                    
                                }];
}


- (void)pickerContactWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //选择联系人
    @weakify(self);
    XNLAddressBookManager *manager = [XNLAddressBookManager sharedInstance];
    [manager selectContactWithViewController:self.curVC
                               completeBlock:^(NSDictionary<NSString *,NSString *> *contact) {
                                   
                                   @strongify(self);
                                   NSString *name = contact[XNLAddressBookContactName];
                                   NSString *mobile = contact[XNLAddressBookContactPhone];
                                   NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
                                   [resultDic ss_setObject:name forKey:@"name"];
                                   [resultDic ss_setObject:mobile forKey:@"phone"];
                                   
                                   [self evaluateJSWithFunc:callBack
                                                   callBack:nil
                                                    dataDic:resultDic
                                          completionHandler:nil];
                               }];
}


- (void)takePhotoWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //拍照
    XNLImageManager *manager = [XNLImageManager sharedInstance];
    [manager takePhotoWithViewController:self.curVC
                           allowsEditing:NO
                           completeBlock:^(UIImage *image) {
                               
                               UIImage *tempImage = [image ss_scaleImageWithScale:0.25];

                               NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.9);
                               NSString *imageDataStr = [imageData ss_Base64EncodedString];
                               NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
                               [resultDic ss_setObject:imageDataStr forKey:@"content"];
                               [self evaluateJSWithFunc:callBack
                                               callBack:nil
                                                dataDic:resultDic
                                      completionHandler:nil];
                           }];
}

- (void)pickerPhotoWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //选择照片
    XNLImageManager *manager = [XNLImageManager sharedInstance];
    [manager pickerPhotoWithViewController:self.curVC
                             allowsEditing:NO
                             completeBlock:^(UIImage *image) {
                                 
                                 UIImage *tempImage = [image ss_scaleImageWithScale:0.25];
        
                                 NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.9);
                                 NSString *imageDataStr = [imageData ss_Base64EncodedString];
                                 NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                 [resultDic ss_setObject:imageDataStr forKey:@"content"];
                                 [self evaluateJSWithFunc:callBack
                                                 callBack:nil
                                                  dataDic:resultDic
                                        completionHandler:nil];
                                 
                                 
                             }];
}

- (void)showLoadingWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //等待框
    int show = [dataDic[@"show"] intValue];
    if (show == 1) {
        [self.curVC showHud];
    } else {
        [self.curVC hideHud];
    }

}

- (void)showToastWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //toast提示
    NSString *msg = dataDic[@"msg"];
    [self.curVC showToastWithText:msg];
}

- (void)cacheDataWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    //缓存数据
    NSString *key = dataDic[@"key"];
    NSString *value = dataDic[@"value"];
    [NSUserDefaults ss_saveObject:value forKey:key];
}


- (void)getCacheDataWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //获取缓存数据
    NSString *key = dataDic[@"key"];
    NSString *value = [NSUserDefaults ss_objectForKey:key];
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [resultDic ss_setObject:key forKey:@"key"];
    [resultDic ss_setObject:value forKey:@"value"];
    [self evaluateJSWithFunc:callBack
                    callBack:nil
                     dataDic:resultDic
           completionHandler:nil];
}





- (void)browserFileWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //NSString *fileName = dataDic[@"filename"];
    NSString *url = dataDic[@"url"];
    XNLRequest *req =
    [XNLRequest requestWithUrl:url
                          actionType:XNLRequestTypeActionDownload
                       requestParams:nil];
    
    @weakify(self);
    [self.curVC showHud];
    [[XNLConnectManager sharedInstance] downloadWithRequest:req progressBlock:nil completeBlock:^(NSURL *filePath, NSError *error) {
        
        @strongify(self);
        [self.curVC hideHud];
        
        if (filePath) {
            //下载成功，预览文件
            @strongify(self);
            XNLFileBrowserViewController *browserVC =
            [[XNLFileBrowserViewController alloc] initWithUrl:filePath];
            [self.curVC pushNormalViewController:browserVC];
        } else {
            [self.curVC showToastWithText:[error ss_message]];
        }
    }];

}



- (void)reportEventWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    NSString *eventId = dataDic[@"eventId"];
    [[XNLDataStatisticsManager sharedInstance] reportWithEventID:eventId];
}


- (void)getUserInfoWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
//    //Mobile+token
//    //XNLUserEntity *userEntity = [XNLUserManager sharedInstance].curUserEntity;
//    NSString *mobile = @"13800000000";  //userEntity.mobile;
//    NSString *token = @"123456";        //userEntity.token;
//    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
//    [resultDic ss_setObject:mobile forKey:@"mobile"];
//    [resultDic ss_setObject:token forKey:@"token"];
//    [self evaluateJSWithFunc:callBack
//                    callBack:nil
//                     dataDic:resultDic
//           completionHandler:nil];
}



- (void)getDeviceInfoWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    XNLUtils *utils = [XNLUtils sharedInstance];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [resultDic ss_setObject:[utils getOSType] forKey:@"osType"];
    [resultDic ss_setObject:[utils getChannelId] forKey:@"channel"];
    [resultDic ss_setObject:[utils getChannelName] forKey:@"channelId"];
    [resultDic ss_setObject:kAPPName forKey:@"appName"];
    [resultDic ss_setObject:kAPPVersion forKey:@"appVersion"];
    [resultDic ss_setObject:kAppCode forKey:@"appCode"];
    
    XNLDeviceModel *deviceModel = [utils getCurDeviceModel];
    [resultDic ss_setObject:deviceModel.model forKey:@"phoneModel"];
    [resultDic ss_setObject:deviceModel.name forKey:@"phoneBrand"];
    
    [resultDic ss_setObject:[utils curNetworkStateName] forKey:@"network"];
    [resultDic ss_setObject:[utils getToken] forKey:@"accessToken"];

    [self evaluateJSWithFunc:callBack
                    callBack:nil
                     dataDic:resultDic
           completionHandler:nil];
}


- (void)recordVideoWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    XNLVideoRecordManager *manager = [XNLVideoRecordManager sharedInstance];
    [manager takeVideoWithViewController:self.curVC
                           completeBlock:^(NSData *video, float duration, float size, NSString *name) {
                               float maxSize = 10;     //最大M
                               float minDuration = 3;  //最小录制时长
                               NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
                               if (size < maxSize && duration > minDuration) {
                                   [resultDic ss_setObject:[video ss_Base64EncodedString] forKey:@"file"];
                                   [self evaluateJSWithFunc:callBack
                                                   callBack:nil
                                                    dataDic:resultDic
                                          completionHandler:nil];
                               }
                               else {
                                   NSLog(@"视频太大或录制时间太短");
                                   [self.curVC showVideoUnavailableAlert];
                               }
                               
                           }];
}




- (void)goToBackForwardWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    //h5页面跳转
    NSString *urlSuffix = dataDic[@"reloadUrlSuffix"];
    if (!urlSuffix.length) {
        return;
    }
    for (WKBackForwardListItem *item in self.curWebView.backForwardList.backList) {
        if ([item.URL.absoluteString hasSuffix:urlSuffix]) {
            [self.curWebView goToBackForwardListItem:item];
        }
    }
}




- (void)shareWithCallBack:(NSString *)callBack dataDic:(NSDictionary *)dataDic {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kXNNotifyName_Share object:nil];
}








@end
