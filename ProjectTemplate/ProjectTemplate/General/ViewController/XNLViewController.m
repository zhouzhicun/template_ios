//
//  XNLViewController.m
//  
//
//  Created by zzc on 16/7/26.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLViewController.h"

@interface XNLViewController ()

/* tableView列表 */
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation XNLViewController


#pragma mark - View Life Cycle

- (void)setupSubView {
    
    [super setupSubView];
    [self createTableView];

}


- (void)createTableView {
    
    //创建tableView
    self.tableView = createView(UITableView);
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    //设置delegate
    [self.tableView ss_setDataSourceDelegate:(id<UITableViewDataSource, UITableViewDelegate>)self];
    
    //隐藏空cell, 并设置背景色
    [self.tableView ss_hideEmptyCell];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
