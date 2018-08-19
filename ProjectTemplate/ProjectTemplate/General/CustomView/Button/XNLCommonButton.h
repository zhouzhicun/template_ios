//
//  XNLCommonButton.h
//  
//
//  Created by zzc on 16/7/4.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+SSToolkitAdditions.h"



typedef NS_ENUM(NSUInteger, XNLButtonContentAlignmentType) {
    XNLButtonContentAlignmentType_Center,           //整体居中
    XNLButtonContentAlignmentType_Linear,           //线性布局
    XNLButtonContentAlignmentType_AlignParent,      //相对父类布局
};

typedef NS_ENUM(NSUInteger, XNLButtonSubViewAlignmentOrder) {
    XNLButtonSubViewAlignmentOrder_Horizontal_Title_Image,      //水平-标题-图标
    XNLButtonSubViewAlignmentOrder_Horizontal_Image_Title,      //水平-图标-标题
    XNLButtonSubViewAlignmentOrder_Vertical_Title_Image,        //垂直-标题-图标
    XNLButtonSubViewAlignmentOrder_Vertical_Image_Title,        //垂直-图标-标题
};



/**
 *  @brief App通用Button
 */
@interface XNLCommonButton : UIButton

@property (nonatomic, assign)UIEdgeInsets touchEdgeInset;   //增大触摸区域


@property (nonatomic, copy) NSNumber *spacing;              //title和image之间的间距: float类型
@property (nonatomic, copy) NSNumber *titlePadding;         //title与Button的间距
@property (nonatomic, copy) NSNumber *imagePadding;         //image与Button的间距

//手动设置titleLabel的size和imageView的size
@property (nonatomic, strong) NSValue *titleSizeValue;
@property (nonatomic, strong) NSValue *imageSizeValue;


- (void)setContentAlignType:(XNLButtonContentAlignmentType)contentAlignType
           subViewOrderType:(XNLButtonSubViewAlignmentOrder)orderType;


@end
