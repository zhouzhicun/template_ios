//
//  XNLBaseTableViewCell.h
//  
//
//  Created by zzc on 15/3/24.
//  Copyright (c) 2015年 . All rights reserved.
//




#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define kXNLDataSourceKey_Cell                  @"cell"
#define kXNLDataSourceKey_CellHeight            @"cell_Height"
#define kXNLDataSourceKey_SEL                   @"cell_SEL"


@interface XNLBaseTableViewCell : UITableViewCell

#pragma mark - Init

- (id)init;

- (id)initWithFrame:(CGRect)frame;

+ (id)createCell;

+ (instancetype)cellForTableView:(UITableView *)tableView;


#pragma mark - UI

//设置subView
- (void)setupSubView;

//设置布局
- (void)setupConstraint;

//设置事件处理
- (void)setupEvent;


#pragma mark - cell高度

- (CGFloat)cellHeight;
+ (CGFloat)cellHeight;


@end
