//
//  UIButton+SSToolkitAdditions.h
//    
//
//  Created by fdd_zzc on 15/11/3.
//  Copyright © 2015年 fdd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSAttributedItemCollection.h"


@interface UIButton (SSToolkitAdditions)

#pragma mark - 设置Title

- (void)ss_setTitle:(SSTextAttributedItem *)textItem forState:(UIControlState)state;

#pragma mark - 设置Icon

- (void)ss_setImage:(SSImageAttributedItem *)imageItem;

#pragma mark - 设置背景图

- (void)ss_setBackground:(SSImageAttributedItem *)imageItem;

@end
