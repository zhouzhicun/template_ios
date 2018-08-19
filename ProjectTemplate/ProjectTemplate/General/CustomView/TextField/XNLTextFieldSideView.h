//
//  XNLTextFieldSideView.h
//  
//
//  Created by zzc on 16/7/14.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNLBaseView.h"

typedef NS_ENUM(NSUInteger, XNLTextFieldSideViewType) {
    
    XNLTextFieldSideViewType_Left,          //输入框leftView
    XNLTextFieldSideViewType_Right,         //输入框rightView
};

@class XNLTextFieldSideView;

@protocol XNLTextFieldProtocol <NSObject>

- (XNLTextFieldSideView *)sideViewWithType:(XNLTextFieldSideViewType)type;

/*
 *  单独设置textfield的leftView或rightView
 */
- (void)setSideView:(XNLTextFieldSideView *)sideView
       SideViewType:(XNLTextFieldSideViewType)sideViewType;


/*
 *  同时设置textfield的leftView和rightView
 */
- (void)setLeftSideView:(XNLTextFieldSideView *)leftSideView
          RightSideView:(XNLTextFieldSideView *)rightSideView;

@end


@interface XNLTextFieldSideView : XNLBaseView

- (CGSize)sideViewSize;

@end
