//
//  XNLParamsConstants.m
//  XNLoan
//
//  Created by zzc on 16/8/11.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLParamsConstants.h"


#pragma mark - Http Header参数

NSString * const kHttpHeaderKey_IsAutoLogin      = @"isAutoLogin";
NSString * const kHttpHeaderKey_AutoToken        = @"autoToken";


NSString *const kHttpHeaderKey_Token             = @"accessToken";
NSString *const kHttpHeaderKey_Channel           = @"channel";
NSString *const kHttpHeaderKey_Version           = @"version";
NSString *const kHttpHeaderKey_ChannelId         = @"channelId";


NSString *const kHttpHeaderKey_DeviceId          = @"deviceId";
NSString *const kHttpHeaderKey_OSType            = @"osType";

NSString *const kHttpHeaderKey_AppCode           = @"appCode";
NSString *const kHttpHeaderKey_AppType           = @"appType";
NSString *const kHttpHeaderKey_IDFA              = @"idfa";
NSString *const kHttpHeaderKey_PhoneType         = @"phoneType";
NSString *const kHttpHeaderKey_PhoneResolution   = @"phoneResolution";
NSString *const kHttpHeaderKey_Network           = @"network";
NSString *const kHttpHeaderKey_LatitudeLongitude = @"latitudeLongitude";


#pragma mark - Http Body参数

//上传文件
NSString *const kHttpRequestKey_UploadFile_files        = @"files";
NSString *const kHttpResponseKey_UploadFile_fileIds     = @"fileIds";



