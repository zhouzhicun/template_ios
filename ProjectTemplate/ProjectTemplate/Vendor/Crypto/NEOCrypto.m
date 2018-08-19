//
//  NEOEncrypt.m
//  
//
//  Created by zzc on 2017/5/17.
//  Copyright © 2017年 . All rights reserved.
//

#import "NEOCrypto.h"
#import "encryptutil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>


@implementation NEOCrypto

#pragma mark - Base64

+ (NSString *)base64Encode:(NSData *)data
{
    if(data == nil) {
        return nil;
    }
    return [data base64EncodedStringWithOptions:0];
}

+ (NSData *)base64Decode:(NSString*)str
{
    if(str == nil) {
        return nil;
    }
    return [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
}




#pragma mark - AES128加解密

//加密data
+ (NSData *)AES128EncryptData:(NSData *)data forKey:(NSString *)key {
    
    if(key == nil || key.length < 16) {
        return nil;
    }
    
    //将nsstring转化为nsdata
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    const char * datakey = [keyData bytes];
    const void * srcdata = [data bytes];
    
    void * dataout = malloc(data.length + kCCBlockSizeAES128);
    size_t datalen = 0;
    NSData * outdata = nil;
    
    
    CCCryptorStatus status = CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding | kCCOptionECBMode,
                                     datakey,
                                     16,
                                     datakey + 16,
                                     srcdata,
                                     data.length,
                                     dataout,
                                     data.length + kCCBlockSizeAES128,
                                     &datalen);
    
    if(status == kCCSuccess) {
        outdata = [NSData dataWithBytes:dataout length:datalen];
    }
    free(dataout);
    return  outdata;
    
    
}









+ (NSData *)AES128DecryptData:(NSData *)data forKey:(NSString *)key
{
    if(key == nil || key.length < 16)
    {
        return nil;
    }
    
    //将nsstring转化为nsdata
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    const char * datakey = [keyData bytes];
    const void * srcdata = [data bytes];
    
    void * dataout = malloc(data.length + kCCBlockSizeAES128);
    size_t datalen = 0;
    NSData * outdata = nil;
    
    
    CCCryptorStatus status = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding | kCCOptionECBMode,
                                     datakey,
                                     16,
                                     datakey + 16,
                                     srcdata,
                                     data.length,
                                     dataout,
                                     data.length + kCCBlockSizeAES128,
                                     &datalen);
    
    if(status == kCCSuccess) {
        outdata = [NSData dataWithBytes:dataout length:datalen];
    }
    free(dataout);
    return  outdata;
}









#pragma mark - AES256加解密

//加密data
+ (NSData *)AES256EncryptWithData:(NSData *)data forKey:(NSString *)key {
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;

}


//解密data
+ (NSData *)AES256DecryptWithData:(NSData *)data forKey:(NSString *)key {
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;

}

//加密string
+ (NSString *)AES256EncryptWithString:(NSString *)str forKey:(NSString *)key {
    
    //将nsstring转化为nsdata
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //使用密码对nsdata进行加密
    NSData *encryptedData = [NEOCrypto AES256EncryptWithData:data forKey:key];
    return [self base64Encode:encryptedData];

}


//解密string
+ (NSString *)AES256DecryptWithString:(NSString *)str forKey:(NSString *)key {
    
    //将字符串base64反编码
    NSData *encryptData = [NEOCrypto base64Decode:str];
    
    //解密
    NSData *decryptData = [NEOCrypto AES256DecryptWithData:encryptData forKey:key];
    NSString *string = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return string;
}





#pragma mark - 3DES加解密

/**
 *3Des加密扩展
 */
+ (NSString*)encrypt3DESWithStr:(NSString *)str {
    
    char outBuf[2048];
    memset(outBuf,0,sizeof(outBuf));
    
    char *bytePtr = (char*)[str UTF8String];
    NSUInteger inLen = strlen((const char *)bytePtr);
    
    int encodeLen = desedeEncode((char*)bytePtr, (char*)&outBuf, (int)inLen);
    
    char hexBuf[2048];
    memset(hexBuf, 0, sizeof(hexBuf));
    byteToHex((unsigned char *)outBuf, (char*)&hexBuf, encodeLen);
    
    return [NSString stringWithCString:(char*)&hexBuf encoding:NSASCIIStringEncoding];
}

/**
 *3Des解密扩展
 */
+ (NSString*)decrypt3DesWithStr:(NSString *)str {
    
    char *bytePtr = (char *)[str UTF8String];
    
    char outBuf[2048];
    memset(outBuf, 0, sizeof(outBuf));
    
    hexStrTobyte((char *)bytePtr, (char *)&outBuf);
    NSUInteger hexStrLen = [str length] / 2;
    
    char decodeBuf[2048];
    memset(decodeBuf, 0, sizeof(decodeBuf));
    
    desedeDecode((char *)&outBuf, (char*)&decodeBuf, (int)hexStrLen);
    
    return [NSString stringWithCString:(const char *)&decodeBuf encoding:4];
    
}


/**
 *3Des加密扩展
 */
+ (NSString*)encrypt3DESWithStr:(NSString *)str forKey:(NSString*)key {
    
    char outBuf[2048];
    memset(outBuf, 0, sizeof(outBuf));
    
    char *bytePtr = (char*)[str UTF8String];
    NSUInteger inLen = strlen((const char*)bytePtr);
    
    int encodeLen = desedeEncodeKey((char *)bytePtr, (char*)&outBuf, (int)inLen, (char*)[key UTF8String]);
    
    char hexBuf[2048];
    memset(hexBuf, 0, sizeof(hexBuf));
    byteToHex((unsigned char*)outBuf, (char*)&hexBuf, encodeLen);
    
    return [NSString stringWithCString:(char*)&hexBuf encoding:NSASCIIStringEncoding];
}


/**
 *3Des解密扩展
 */
+ (NSString*)decrypt3DesWithStr:(NSString *)str forKey:(NSString*)key {
    
    char *bytePtr = (char *)[str UTF8String];
    
    char outBuf[2048];
    memset(outBuf, 0, sizeof(outBuf));
    
    hexStrTobyte((char*)bytePtr, (char*)&outBuf);
    NSUInteger hexStrLen = [str length] / 2;
    
    char decodeBuf[2048];
    memset(decodeBuf, 0, sizeof(decodeBuf));
    
    desedeDecodeKey((char *)&outBuf, (char *)&decodeBuf, (int)hexStrLen, (char *)[key UTF8String]);
    
    return [NSString stringWithCString:(const char *)&decodeBuf encoding:4];
}







#pragma mark - 其他加密

+ (NSString *)md5:(NSString *)input {
    
    if(input == nil) {
        return @"";
    }
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}



+ (NSString *)sha1:(NSString *)input {
    
    NSData * data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}






@end
