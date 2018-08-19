//
//  XNLRootWebViewController.m
//  
//
//  Created by zzc on 2018/7/2.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLRootWebViewController.h"

#import "XNLWebConstants.h"
#import "XNLThirdPartSDKConfigMacro.h"
#import "XNLServerAddrVC.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface XNLRootWebViewController ()

@end

@implementation XNLRootWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    
    [self addNotify];
}


#pragma mark - Public

- (void)addNotify {
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kXNNotifyName_Share object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         
         @strongify(self);
         [self share];
     }];
}


- (void)backButtonPressed:(id)sender {
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self showToastWithText:@"已回到首页"];
    }
}

- (void)configNavigationBar
{
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.barTintColor = HEXCOLOR(0x4995F1);
    
    //隐藏导航栏下的黑线
    [bar setShadowImage:[UIImage new]];
    
    //2 设置导航栏标题样式
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName:HEXCOLOR(0xffffff), NSFontAttributeName:scaleFontSize(18)};
    [bar setTitleTextAttributes:attributes];
    

    @weakify(self);
    CGFloat offset = 14;
    [self ss_addBarButtonWithNormalImageName:@"tabbar_item_home_normal"
                          highLightImageName:@"tabbar_item_home_normal"
                           barButtonItemType:SSBarButtonItemTypeRight
                                      offset:offset
                                pressedBlock:^(UIButton *button){
                                    
                                    @strongify(self);
                                    [self configServerAddr];
                                }];
}

//设置服务器地址
- (void)configServerAddr {

    XNLServerAddrVM *vm = [[XNLServerAddrVM alloc] init];
    XNLServerAddrVC *serverAddrVC = [[XNLServerAddrVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:serverAddrVC animated:YES];
}



- (void)share {
 
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"guide_enter_button_selected"]];
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"快来看看"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"神奇的动物世界"
                                           type:SSDKContentTypeAuto];
        
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        
        //大家请注意：4.1.2版本开始因为UI重构了下，所以这个弹出分享菜单的接口有点改变，如果集成的是4.1.2以及以后版本，如下调用：
        [ShareSDK showShareActionSheet:nil customItems:nil shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    [self showAlertWithTitle:@"分享成功" message:nil
                           cancelActionTitle:@"确定" okActionTitle:nil
                                cancelAction:nil okAction:nil];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    [self showAlertWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error]
                           cancelActionTitle:@"确定" okActionTitle:nil
                                cancelAction:nil okAction:nil];
                    break;
                }
                default:
                    break;
            }
        }];
        
    }
}


@end
