//
//  URLMacro.h
//  
//
//  Created by zzc on 15/3/23.
//  Copyright (c) 2015年 . All rights reserved.
//  


#ifndef XNL_App_Global_Config_Macro_h
#define XNL_App_Global_Config_Macro_h


/**
 *  AppId,跳转AppStore使用
 */

//
#define kAppStoreAppId @"111111"


/**
 *  AppCode配置
 *  例如: 4.2.0版本对应AppCode 420
 */
#define kAppCode @"100"

/**
 *  接口环境配置:1 开发环境; 2 测试环境; 3 预发布环境; 4 发布环境;
 */
#define Configure_Environment 1

/**
 *  接口是否加密:0 不加密; 1 加密
 */
#define Configure_API_Encrypt 0


#endif
