//
//  XNLCommonButton.m
//  
//
//  Created by zzc on 16/7/4.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLCommonButton.h"


@interface XNLCommonButton ()

@property (nonatomic, copy) NSNumber *isCustomLayout;   //默认为nil, 表示未自定义Layout

@property (nonatomic, assign) XNLButtonContentAlignmentType contentAlignType;       //内容整体对齐类型
@property (nonatomic, assign) XNLButtonSubViewAlignmentOrder subViewOrderType;      //subView排列顺序类型


@end

@implementation XNLCommonButton



//设置内容对齐方式以及subview排列顺序
- (void)setContentAlignType:(XNLButtonContentAlignmentType)contentAlignType
           subViewOrderType:(XNLButtonSubViewAlignmentOrder)orderType {
    
    self.isCustomLayout = @(YES);
    self.contentAlignType = contentAlignType;
    self.subViewOrderType = orderType;
}



- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //判断是否自定义Layout
    if (self.isCustomLayout.boolValue) {

        switch (self.contentAlignType) {
            case XNLButtonContentAlignmentType_Center: {
                //居中对齐
                [self resetCenterLayout];
                break;
            }
            case XNLButtonContentAlignmentType_Linear: {
                //线性对齐
                [self resetLinearLayout];
                break;
            }
            case XNLButtonContentAlignmentType_AlignParent: {
                //相对父view对齐
                [self resetAlignParentLayout];
                break;
            }
        }
    }
}


- (void)resetCenterLayout {
    
    CGSize buttonSize = self.bounds.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize imageSize = self.imageView.frame.size;
    
    if (self.titleSizeValue) {
        titleSize = self.titleSizeValue.CGSizeValue;
    }
    if (self.imageSizeValue) {
        imageSize = self.imageSizeValue.CGSizeValue;
    }
    
    
    
    CGFloat space = self.spacing.floatValue;   //间距值
    switch (self.subViewOrderType) {
        case XNLButtonSubViewAlignmentOrder_Horizontal_Title_Image:{
            
            //水平-Title-Image
            CGFloat leftPadding = (buttonSize.width - titleSize.width - imageSize.width - space) / 2.0;
            
            self.titleLabel.frame = ({
                CGRect rect = self.titleLabel.frame;
                rect.origin.x = leftPadding;
                rect.origin.y = (buttonSize.height - titleSize.height) / 2.0;
                rect.size = titleSize;
                rect;
            });
            self.imageView.frame = ({
                CGRect rect = self.imageView.frame;
                rect.origin.x = leftPadding + titleSize.width + space;
                rect.origin.y = (buttonSize.height - imageSize.height) / 2.0;
                rect.size = imageSize;
                rect;
            });
            
            break;
        }
        case XNLButtonSubViewAlignmentOrder_Horizontal_Image_Title:{
            //水平-Image-Title
            CGFloat leftPadding = (buttonSize.width - titleSize.width - imageSize.width - space) / 2.0;
            
            self.imageView.frame = ({
                CGRect rect = self.imageView.frame;
                rect.origin.x = leftPadding;
                rect.origin.y = (buttonSize.height - imageSize.height) / 2.0;
                rect.size = imageSize;
                rect;
            });
            
            self.titleLabel.frame = ({
                CGRect rect = self.titleLabel.frame;
                rect.origin.x = leftPadding + imageSize.width + space;
                rect.origin.y = (buttonSize.height - titleSize.height) / 2.0;
                rect.size = titleSize;
                rect;
            });

            break;
        }
        case XNLButtonSubViewAlignmentOrder_Vertical_Title_Image:{
            //垂直-Title-Image
            CGFloat topPadding = (buttonSize.height - titleSize.height - imageSize.height - space) / 2.0;
            
            self.titleLabel.frame = ({
                CGRect rect = self.titleLabel.frame;
                rect.origin.x = (buttonSize.width - titleSize.width) / 2.0;
                rect.origin.y = topPadding;
                rect.size = titleSize;
                rect;
            });
            
            self.imageView.frame = ({
                CGRect rect = self.imageView.frame;
                rect.origin.x = (buttonSize.width - imageSize.width) / 2.0;
                rect.origin.y = topPadding + titleSize.height + space;
                rect.size = imageSize;
                rect;
            });
            break;
        }
        case XNLButtonSubViewAlignmentOrder_Vertical_Image_Title:{
            //垂直-Image-Title
            CGFloat topPadding = (buttonSize.height - titleSize.height - imageSize.height - space) / 2.0;
            
            self.imageView.frame = ({
                CGRect rect = self.imageView.frame;
                rect.origin.x = (buttonSize.width - imageSize.width) / 2.0;
                rect.origin.y = topPadding;
                rect.size = imageSize;
                rect;
            });
            
            self.titleLabel.frame = ({
                CGRect rect = self.titleLabel.frame;
                rect.origin.x = (buttonSize.width - titleSize.width) / 2.0;
                rect.origin.y = topPadding + imageSize.height + space;
                rect.size = titleSize;
                rect;
            });
            
            
            break;
        }

    }
}



- (void)resetLinearLayout {
    
    CGSize buttonSize = self.bounds.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize imageSize = self.imageView.frame.size;
    
    if (self.titleSizeValue) {
        titleSize = self.titleSizeValue.CGSizeValue;
    }
    if (self.imageSizeValue) {
        imageSize = self.imageSizeValue.CGSizeValue;
    }
    
    switch (self.subViewOrderType) {
        case XNLButtonSubViewAlignmentOrder_Horizontal_Title_Image:{
            //水平-Title-Image
            CGFloat leftPadding = self.titlePadding.floatValue;
            CGFloat space = self.spacing.floatValue;
            
            self.titleLabel.frame = ({
                CGRect frame = self.titleLabel.frame;
                frame.origin.x = leftPadding;
                frame.origin.y = (buttonSize.height - titleSize.height) / 2.0;
                frame.size = titleSize;
                frame;
            });
            
            self.imageView.frame = ({
                CGRect frame = self.imageView.frame;
                frame.origin.x = leftPadding + titleSize.width + space;
                frame.origin.y = (buttonSize.height - imageSize.height) / 2.0;
                frame.size = imageSize;
                frame;
            });

            break;
        }
        case XNLButtonSubViewAlignmentOrder_Horizontal_Image_Title:{
            //水平-Image-Title
            
            CGFloat leftPadding = self.imagePadding.floatValue;
            CGFloat space = self.spacing.floatValue;
            
            self.imageView.frame = ({
                CGRect frame = self.imageView.frame;
                frame.origin.x = leftPadding;
                frame.origin.y = (buttonSize.height - imageSize.height) / 2.0;
                frame.size = imageSize;
                frame;
            });
            
            self.titleLabel.frame = ({
                CGRect frame = self.titleLabel.frame;
                frame.origin.x = leftPadding + imageSize.width + space;
                frame.origin.y = (buttonSize.height - titleSize.height) / 2.0;
                frame.size = titleSize;
                frame;
            });
            
            break;
        }
        case XNLButtonSubViewAlignmentOrder_Vertical_Title_Image:{
            //垂直-Title-Image
            CGFloat topPadding = self.titlePadding.floatValue;
            CGFloat space = self.spacing.floatValue;
            
            self.titleLabel.frame = ({
                CGRect frame = self.titleLabel.frame;
                frame.origin.x = (buttonSize.width - titleSize.width) / 2.0;
                frame.origin.y = topPadding;
                frame.size = titleSize;
                frame;
            });
            
            self.imageView.frame = ({
                CGRect frame = self.imageView.frame;
                frame.origin.x = (buttonSize.width - imageSize.width) / 2.0;
                frame.origin.y = topPadding + titleSize.height + space;
                frame.size = imageSize;
                frame;
            });
            

            
            break;
        }
        case XNLButtonSubViewAlignmentOrder_Vertical_Image_Title:{
            //垂直-Image-Title
            CGFloat topPadding = self.imagePadding.floatValue;
            CGFloat space = self.spacing.floatValue;
            
            self.imageView.frame = ({
                CGRect frame = self.imageView.frame;
                frame.origin.x = (buttonSize.width - imageSize.width) / 2.0;
                frame.origin.y = topPadding;
                frame.size = imageSize;
                frame;
            });
            
            self.titleLabel.frame = ({
                CGRect frame = self.titleLabel.frame;
                frame.origin.x = (buttonSize.width - titleSize.width) / 2.0;
                frame.origin.y = topPadding + imageSize.height + space;
                frame.size = titleSize;
                frame;
            });
            
            break;
        }
            
    }
    
}

- (void)resetAlignParentLayout {
    
    CGSize buttonSize = self.bounds.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize imageSize = self.imageView.frame.size;
    
    if (self.titleSizeValue) {
        titleSize = self.titleSizeValue.CGSizeValue;
    }
    
    if (self.imageSizeValue) {
        imageSize = self.imageSizeValue.CGSizeValue;
    }
    
    
    CGFloat titlePadding = self.titlePadding.floatValue;
    CGFloat imagePadding = self.imagePadding.floatValue;
    
    switch (self.subViewOrderType) {
        case XNLButtonSubViewAlignmentOrder_Horizontal_Title_Image:{
            //水平-Title-Image
            self.titleLabel.frame = ({
                CGRect frame = self.titleLabel.frame;
                frame.origin.x = titlePadding;
                frame.origin.y = (buttonSize.height - titleSize.height) / 2.0;
                frame.size = titleSize;
                frame;
            });
            
            self.imageView.frame = ({
                CGRect frame = self.imageView.frame;
                frame.origin.x = buttonSize.width - imagePadding - imageSize.width;
                frame.origin.y = (buttonSize.height - imageSize.height) / 2.0;
                frame.size = imageSize;
                frame;
            });
            
            break;
        }
        case XNLButtonSubViewAlignmentOrder_Horizontal_Image_Title:{
            //水平-Image-Title
            self.imageView.frame = ({
                CGRect frame = self.imageView.frame;
                frame.origin.x = imagePadding;
                frame.origin.y = (buttonSize.height - imageSize.height) / 2.0;
                frame.size = titleSize;
                frame;
            });
            
            self.titleLabel.frame = ({
                CGRect frame = self.titleLabel.frame;
                frame.origin.x = buttonSize.width - titlePadding - titleSize.width;
                frame.origin.y = (buttonSize.height - titleSize.height) / 2.0;
                frame.size = imageSize;
                frame;
            });

            break;
        }
        case XNLButtonSubViewAlignmentOrder_Vertical_Title_Image:{
            //垂直-Title-Image
            self.titleLabel.frame = ({
                CGRect frame = self.titleLabel.frame;
                frame.origin.x = (buttonSize.width - titleSize.width) / 2.0;
                frame.origin.y = titlePadding;
                frame.size = titleSize;
                frame;
            });
            
            self.imageView.frame = ({
                CGRect frame = self.imageView.frame;
                frame.origin.x = (buttonSize.width - imageSize.width) / 2.0;
                frame.origin.y = buttonSize.height - imagePadding - imageSize.height;
                frame.size = imageSize;
                frame;
            });
            
            break;
        }
        case XNLButtonSubViewAlignmentOrder_Vertical_Image_Title:{
            //垂直-Image-Title
            self.imageView.frame = ({
                CGRect frame = self.imageView.frame;
                frame.origin.x = (buttonSize.width - imageSize.width) / 2.0;
                frame.origin.y = imagePadding;
                frame.size = imageSize;
                frame;
            });
            
            self.titleLabel.frame = ({
                CGRect frame = self.titleLabel.frame;
                frame.origin.x = (buttonSize.width - titleSize.width) / 2.0;
                frame.origin.y = buttonSize.height - titlePadding - titleSize.height;
                frame.size = titleSize;
                frame;
            });
            
            break;
        }
            
    }
    
}




#pragma mark - 点击区域处理

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*) event {
    
    UIEdgeInsets edgeInset = self.touchEdgeInset;
    CGRect rect = CGRectMake(self.bounds.origin.x - edgeInset.left,
                             self.bounds.origin.y - edgeInset.top,
                             self.bounds.size.width + edgeInset.left + edgeInset.right,
                             self.bounds.size.height + edgeInset.top + edgeInset.bottom);
    
    BOOL isEdgeInsetZero = UIEdgeInsetsEqualToEdgeInsets(edgeInset, UIEdgeInsetsZero);
    BOOL isInvalidView = self.hidden || self.alpha == 0 || !self.enabled || !self.isUserInteractionEnabled;
    
    if (isInvalidView) {
        return [super hitTest:point withEvent:event];
    } else {
        if (isEdgeInsetZero) {
            return [super hitTest:point withEvent:event];
        } else {
            return CGRectContainsPoint(rect, point) ? self : nil;
        }
    }
    
    return nil;
}


@end
