//
//  NEOEncrypt.h
//  
//
//  Created by zzc on 2017/5/17.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEOCrypto : NSObject


#pragma mark - Base64

+ (NSString *)base64Encode:(NSData *)data;
+ (NSData *)base64Decode:(NSString*)str;


#pragma mark - AES128加解密

+ (NSData *)AES128EncryptData:(NSData *)data forKey:(NSString *)key;
+ (NSData *)AES128DecryptData:(NSData *)data forKey:(NSString *)key;




#pragma mark - AES256加解密
+ (NSData *)AES256EncryptWithData:(NSData *)data forKey:(NSString *)key;   //加密data
+ (NSData *)AES256DecryptWithData:(NSData *)data forKey:(NSString *)key;   //解密data

+ (NSString *)AES256EncryptWithString:(NSString *)str forKey:(NSString *)key;   //加密string
+ (NSString *)AES256DecryptWithString:(NSString *)str forKey:(NSString *)key;   //解密string








#pragma mark - 3DES加解密


/**
 *3Des加密扩展
 */
+ (NSString*)encrypt3DESWithStr:(NSString *)str;

/**
 *3Des解密扩展
 */
+ (NSString*)decrypt3DesWithStr:(NSString *)str;


/**
 *3Des加密扩展
 */
+ (NSString*)encrypt3DESWithStr:(NSString *)str forKey:(NSString*)key;


/**
 *3Des解密扩展
 */
+ (NSString*)decrypt3DesWithStr:(NSString *)str forKey:(NSString*)key;




#pragma mark - 其他加密

+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;





@end
