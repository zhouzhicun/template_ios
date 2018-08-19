//
//  NSMutableAttributedString+SSToolkitAdditions.h
//  
//
//  Created by zzc on 16/7/20.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UILabel+SSToolkitAdditions.h"

@interface NSMutableAttributedString (SSToolkitAdditions)

- (void)ss_setTextAttribute:(SSTextAttributedItem *)attrItem;

@end
