//
//  XNLNavigationController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "XNLNavigationController.h"

@interface XNLNavigationController ()
<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation XNLNavigationController

#pragma mark - Life Cycle
#pragma mark -- Initialier Methods
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        //默认关闭， 禁止侧滑返回
        self.canDragBack = NO;
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)loadView
{
    [super loadView];
    
//    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.navigationBar.bounds), CGRectGetWidth(self.navigationBar.bounds), 0.5f)];
//    horizontalLine.backgroundColor = kSplitLineColor;
//    [self.navigationBar addSubview:horizontalLine];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{
                                               NSForegroundColorAttributeName: HEXCOLOR(0x333333),
                                               NSFontAttributeName: scaleFontSize(18.0f)
                                               };
    self.navigationBar.tintColor = HEXCOLOR(0x333333);
    self.navigationBar.barTintColor = HEXCOLOR(0xFFFFFF);
    self.navigationBar.translucent = NO;
    
//    UIImage *bgImage = [UIImage imageNamed:Global_Navigation_background];
//    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch];
//    
//    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
//    // 获取系统自带滑动手势的target对象
//    id target = self.interactivePopGestureRecognizer.delegate;
//    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    SEL sel_f = sel_registerName("handleNavigationTransition:");
//    if( [target respondsToSelector:sel_f] )
//    {
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:sel_f];
//        // 设置手势代理，拦截手势触发
//        pan.delegate = self;
//        // 给导航控制器的view添加全屏滑动手势
//        [self.view addGestureRecognizer:pan];
//        // 禁止使用系统自带的滑动手势
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    else
    {
        __weak typeof (self) weakSelf = self;
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.delegate = weakSelf;
            self.delegate = weakSelf;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - Override Super Method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    return YES;
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers firstObject]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) {
        return NO;
    }
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    //    if(gestureRecognizer==popPanGestureRecognizer && otherGestureRecognizer==self.interactivePopGestureRecognizer)
//    //        return YES;
//    return NO;
//}

@end
