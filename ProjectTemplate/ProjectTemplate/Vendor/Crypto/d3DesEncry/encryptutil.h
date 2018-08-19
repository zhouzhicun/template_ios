/*
 *  encryptutil.h
 *  SecStudy
 *
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

/**
 *char*字符串 3des加密方法
 */
unsigned int desedeEncode(char* inbuf,char* outbuf,int inputlen);

/**
 *char*字符串 3des解密方法
 */
unsigned int desedeDecode(char* inbuf,char* outbuf,int inputlen);

/**
 *RSA+MD5签名
 */
unsigned int rsaSign(char* outbuf,unsigned int* outlen,char* inbuf,unsigned int inputlen);

/**
 *unsigned char* 转换成16进制字符串
 */
int byteToHex(unsigned char* puc,char* pc,int uclength);

/**
 *16进制字符串 转char*数组
 */
int hexStrTobyte(char* hexStr,char* outbuf);



#pragma =====================扩展
/**
 *char*字符串 3des加密方法
 */
unsigned int desedeEncodeKey(char* inbuf,char* outbuf,int inputlen,char* key);

/**
 *char*字符串 3des解密方法
 */
unsigned int desedeDecodeKey(char* inbuf,char* outbuf,int inputlen,char* key);