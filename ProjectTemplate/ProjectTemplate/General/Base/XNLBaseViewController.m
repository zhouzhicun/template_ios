//
//  XNLBaseViewController.m
//  
//
//  Created by zzc on 15/3/23.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "XNLBaseViewController.h"

//RunTime
#import <objc/runtime.h>

@interface XNLBaseViewController ()

//背景
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation XNLBaseViewController


#pragma mark - Init

- (instancetype)initWithViewModel:(XNLBaseViewModel *)viewModel {
    
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    
    return self;
}

- (void)setViewModel:(id)viewModel {}
- (XNLBaseViewModel *)viewModel {
    return nil;
}



#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1 base初始化
    [self baseCommonInit];
    [self commonInit];
}



#pragma mark - commonInit

- (void)baseCommonInit {
    
    //1 设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //2 以导航栏左下角为原点，进行布局; 默认是以以屏幕左上角为原点。
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {} else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 设置导航栏默认样式
    [self configDefautNavigationBar];
}

- (void)commonInit {

    //2 设置UI
    [self setupSubView];
    [self setupConstraint];
    [self setupEvent];
    [self setupBinding];

}


#pragma mark - UI
- (void)setupSubView{}
- (void)setupConstraint{}
- (void)setupEvent{}
- (void)setupBinding {
    
    self.title = self.viewModel.navBarTitle;
    
    @weakify(self);
    [[self.viewModel.toastSubject deliverOnMainThread] subscribeNext:^(NSString *message) {
        @strongify(self);
        [self showToastWithText:message];
    }];
    
    [[self.viewModel.loadingSubject deliverOnMainThread] subscribeNext:^(NSNumber *show) {
        @strongify(self);
        if (show && [show boolValue]) {
            [self showHud];
        } else {
            [self hideHud];
        }
    }];
    
    [[self.viewModel.successSubject deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        [self dispatchSuccessWithEvent:tuple.first data:tuple.second];
    }];
    
    [[self.viewModel.errorSubject deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        [self dispatchErrorWithEvent:tuple.first data:tuple.second];
    }];
    
}


#pragma mark - Public

- (void)backButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}

/* 创建锚点 */
- (void)createAnchorWithBlock:(UIViewControllerPopBackToAnchorBlock)block
{
    self.isAnchor = YES;
    self.popBackToAnchorBlock = block;
}

/* 用于界面中textfiled的RAC绑定 */
- (void)bindingTextField:(UITextField *)textfield
         channelTerminal:(RACChannelTerminal *)channel {
    
    RACChannelTerminal *textFieldChannel = textfield.rac_newTextChannel;
    [channel subscribe:textFieldChannel];
    [textFieldChannel subscribe:channel];
}


//分发处理请求成功
- (void)dispatchSuccessWithEvent:(NSString *)event data:(id)data {
    
}

//分发处理请求失败
- (void)dispatchErrorWithEvent:(NSString *)event data:(id)data {
    
}



#pragma mark - Private


//设置默认导航栏样式
- (void)configDefautNavigationBar
{
    //1 设置返回按钮
    @weakify(self);
    CGFloat offset = 14;
    [self ss_addBarButtonWithNormalImageName:@"global_navigation_default_back"
                          highLightImageName:@"global_navigation_default_back"
                           barButtonItemType:SSBarButtonItemTypeLeft
                                      offset:offset
                                pressedBlock:^(UIButton *button){
                                    
                                    @strongify(self);
                                    [self backButtonPressed:button];
                                }];
    
    
    //2 设置导航栏标题样式
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName:HEXCOLOR(0x333333), NSFontAttributeName:scaleFontSize(18)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}



#pragma mark - Getter

- (MBProgressHUD *)hud
{
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        
//        _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//        _hud.bezelView.backgroundColor = [UIColor clearColor];
//
//        _hud.minSize = CGSizeMake(120.0f, 25.0f);
//        _hud.margin = 0.f;
//        _hud.animationType = MBProgressHUDAnimationFade;
//        _hud.detailsLabel.font = scaleFontSize(13);
//        _hud.removeFromSuperViewOnHide = YES;
        
    }
    
    return _hud;
    
}


@end
