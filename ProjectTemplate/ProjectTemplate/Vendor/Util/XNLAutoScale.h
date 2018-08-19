//
//  AutoScale.h
//
//  Created by zzc on 2017/11/1.
//  Copyright © 2017年 AAma. All rights reserved.
//

@import UIKit;


BOOL iPhoneX(void);

#pragma mark -- size, 字体size

/** X 缩放 */
CGFloat scaleX(CGFloat value);

/** Y 缩放 */
CGFloat scaleY(CGFloat value);

/** 字体 缩放 */
UIFont *scaleFontSize(CGFloat fontSize);

/** 粗体字体 缩放 */
UIFont *scaleBoldFontSize(CGFloat fontSize);




#pragma mark -- 状态栏，导航栏，Tabbar, 底部

CGFloat getStatusBarHeight(void);
CGFloat getNavigationBarHeight(void);
CGFloat getStatusAndNavBarHeight(void);
CGFloat getTabBarHeight(void);
CGFloat getIphoneXInsetBottom(void);

