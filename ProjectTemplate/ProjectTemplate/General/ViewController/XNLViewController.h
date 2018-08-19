//
//  XNLViewController.h
//  
//
//  Created by zzc on 16/7/26.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLBaseViewController.h"


/**
 *  用于非列表页面
 *  (主要用于适配，由于设计图一般以4寸屏设计，在4,4s上显示不全，通过页面滚动进行展示)
 *  开发过程中，所有subview添加到某个containerView, 并设置为tableview的headerview即可。
 */
@interface XNLViewController : XNLBaseViewController <UITableViewDataSource, UITableViewDelegate>

/* tableView列表 */
@property (nonatomic, strong, readonly) UITableView *tableView;


- (void)setupSubView NS_REQUIRES_SUPER;



@end
