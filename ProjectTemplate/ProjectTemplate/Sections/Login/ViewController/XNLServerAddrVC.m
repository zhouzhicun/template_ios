//
//  XNLServerAddrViewController.m
//  
//
//  Created by zzc on 2018/5/14.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLServerAddrVC.h"
#import "XNLUserManager.h"


@interface XNLServerAddrVC ()

@property (nonatomic, strong) UILabel *curAddrTipLabel;
@property (nonatomic, strong) UILabel *curAddrValueLabel;

@property (nonatomic, strong) UILabel *inputAddrTipLabel;
@property (nonatomic, strong) UITextField *addrTextField;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation XNLServerAddrVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.curAddrValueLabel.text = [self.viewModel getCurrentAddr];
}

#pragma mark - Super Methods
#pragma mark -- UI
- (void)setupSubView {

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.curAddrTipLabel];
    [self.view addSubview:self.curAddrValueLabel];
    [self.view addSubview:self.inputAddrTipLabel];
    [self.view addSubview:self.addrTextField];
    [self.view addSubview:self.saveButton];
}

- (void)setupConstraint {
    
    CGFloat leftOffset = 15;
    [self.curAddrTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(leftOffset);
    }];
    
    [self.curAddrValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.curAddrTipLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(leftOffset);
        make.right.mas_equalTo(-leftOffset);
    }];
    
    [self.inputAddrTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.curAddrValueLabel.mas_bottom).offset(28);
        make.left.mas_equalTo(leftOffset);
    }];
    
    [self.addrTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputAddrTipLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(leftOffset);
        make.width.mas_equalTo(kScreenWidth -  2*leftOffset);
        make.height.mas_equalTo(48);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addrTextField.mas_bottom).offset(40);
        make.left.mas_equalTo(leftOffset);
        make.width.mas_equalTo(kScreenWidth -  2*leftOffset);
        make.height.mas_equalTo(48);

    }];
    
}

- (void)setupEvent {
    [self.saveButton bk_addEventHandler:^(id sender) {
        
        if ([self.viewModel validForm]) {
            [self.viewModel cacheAddr];
            [super backButtonPressed:nil];  //返回上一页面
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupBinding {
    [super setupBinding];
    
    // addr
    [self bindingTextField:self.addrTextField
           channelTerminal:RACChannelTo(self.viewModel, addr)];
    
}


#pragma mark - Private Methods


- (UILabel *)curAddrTipLabel {
    if (!_curAddrTipLabel) {
        _curAddrTipLabel = createView(UILabel);
        [_curAddrTipLabel ss_setText:SSTextAttrItem(@"当前首页地址:", scaleFontSize(16), HEXCOLOR(0x000000))];
    }
    return _curAddrTipLabel;
}

- (UILabel *)curAddrValueLabel {
    if (!_curAddrValueLabel) {
        _curAddrValueLabel = createView(UILabel);
        _curAddrValueLabel.numberOfLines = 0;
        [_curAddrValueLabel ss_setText:SSTextAttrItem(@"", scaleFontSize(16), HEXCOLOR(0x000000))];
    }
    return _curAddrValueLabel;
}

- (UILabel *)inputAddrTipLabel {
    if (!_inputAddrTipLabel) {
        _inputAddrTipLabel = createView(UILabel);
        [_inputAddrTipLabel ss_setText:SSTextAttrItem(@"首页新地址", scaleFontSize(16), HEXCOLOR(0x000000))];
    }
    return _inputAddrTipLabel;
}


- (UITextField *)addrTextField {
    
    if (!_addrTextField) {
        _addrTextField = createView(UITextField);
        [_addrTextField ss_setCornerRadius:4];
        [_addrTextField ss_setBorderWidth:1 borderColor:HEXCOLOR(0xff0000)];
        [_addrTextField ss_setFont:scaleFontSize(16) Color:HEXCOLOR(0x000000)];
        [_addrTextField ss_setPlaceHolder:@"请输入首页新地址" font:scaleFontSize(16) color:HEXCOLOR(0xCCCCCC)];
        
        UILabel *leftLabel = createView(UILabel);
        leftLabel.frame = CGRectMake(0, 0, 4, 4);

        _addrTextField.leftView = leftLabel;
        _addrTextField.leftViewMode = UITextFieldViewModeAlways;
        
        
    }
    return _addrTextField;
}

- (UIButton *)saveButton {
    
    if (!_saveButton) {
        _saveButton = createView(UIButton);
        
        SSTextAttributedItem *textItem = SSTextAttrItem(@"保存", scaleFontSize(18.0f), HEXCOLOR(0xFFFFFF));
        [_saveButton ss_setTitle:textItem forState:UIControlStateNormal];
        
        UIImage *normalBGImage = [UIImage ss_imageWithColor:HEXCOLOR(0x445B95) size:CGSizeMake(1, 1)];
        UIImage *disableBGImage = [UIImage ss_imageWithColor:HEXCOLOR(0xCCCCCC) size:CGSizeMake(1, 1)];
        
        SSImageAttributedItem *imageItem = SSImageAttrItemWithImage(normalBGImage, normalBGImage, normalBGImage, disableBGImage);
        [_saveButton ss_setBackground:imageItem];
        [_saveButton ss_setCornerRadius:scaleY(24.0f)];
    }
    return _saveButton;
}

@end
