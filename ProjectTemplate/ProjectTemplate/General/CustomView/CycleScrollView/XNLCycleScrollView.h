//
//  XNLCycleScrollView.h
//
//
//  Created by fdd_zzc on 15/4/28.
//  Copyright (c) 2015年 fdd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XNLCycleTapActionBlock)(NSNumber *index);

@interface XNLCycleScrollView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, copy) XNLCycleTapActionBlock tapActionBlock;

//初始化
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

//配置CycleView数据源
- (void)setupCycleViewWithDataArr:(NSArray *)dataArr defaultImage:(UIImage *)defaultImage;



- (void)startScroll;

- (void)stopScroll;

@end
