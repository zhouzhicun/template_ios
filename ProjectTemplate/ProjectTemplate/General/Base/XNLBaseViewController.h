//
//  XNLBaseViewController.h
//  
//
//  Created by zzc on 15/3/23.
//  Copyright (c) 2015年 . All rights reserved.
//

//Catergories
#import "UINavigationController+VLVAnchorStack.h"

//View Models
#import "XNLBaseViewModel.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"

#import "XNLNavigationController.h"


typedef NS_ENUM(NSInteger, XNLBarButtonItemType) {
    XNLBarButtonItemTypeLeft,
    XNLBarButtonItemTypeRight
};


@interface XNLBaseViewController : UIViewController

/* Hud */
@property (nonatomic, strong, readonly) MBProgressHUD *hud;

//Init
- (instancetype)initWithViewModel:(XNLBaseViewModel *)viewModel;
- (void)setViewModel:(id)viewModel;
- (XNLBaseViewModel *)viewModel;


#pragma mark - UI
- (void)setupSubView;
- (void)setupConstraint;
- (void)setupEvent;
- (void)setupBinding NS_REQUIRES_SUPER;


#pragma mark - Public

- (void)backButtonPressed:(id)sender;

- (void)hideKeyBoard;

/* 创建锚点 */
- (void)createAnchorWithBlock:(UIViewControllerPopBackToAnchorBlock)block;


/**
 * 用于界面中textfiled的RAC绑定, 例如:
 *
 * [self bindingTextField:self.mobileTextField channelTerminal:RACChannelTo(self.vm, mobile)];
 *
 */
- (void)bindingTextField:(UITextField *)textfield
         channelTerminal:(RACChannelTerminal *)channel;


//分发处理请求成功
- (void)dispatchSuccessWithEvent:(NSString *)event data:(id)data;

//分发处理请求失败
- (void)dispatchErrorWithEvent:(NSString *)event data:(id)data;


@end



#import "XNLBaseViewController+Push.h"
#import "XNLBaseViewController+TipView.h"

