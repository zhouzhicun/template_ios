//
//  XNLBaseView.h
//  
//
//  Created by zzc on 16/6/15.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNLBaseView : UIView

#pragma mark - Init

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;


/**
 * common初始化, 只供调用，不重写， 用于自定义View时，其他Init方法调用
 *
 */
- (void)commonInit;


#pragma mark - UI

//设置subView
- (void)setupSubView;

//设置布局
- (void)setupConstraint;

//设置事件处理
- (void)setupEvent;

#pragma mark - View高度

- (CGFloat)viewHeight;
+ (CGFloat)viewHeight;

@end
