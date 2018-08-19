/*
 *  encryptutil.c
 *  SecStudy
 *
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "encryptutil.h"
#include "d3des.h"
#include <string.h>
#include <stdlib.h>


static char *keystr="XNL-BCES-IBP-IBANK-IBP-3DES";

/**
 *char*字符串 3des加密方法
 */
unsigned int desedeEncode(char* inbuf,char* outbuf,int inputlen)
{
	return DESede_Encrypt(outbuf,inbuf,inputlen, keystr);
}


/**
 *char*字符串 3des解密方法
 */
unsigned int desedeDecode(char* inbuf,char* outbuf,int inputlen)
{
	int tmpLen=DESede_Decrypt(outbuf,inbuf, inputlen,keystr);
	outbuf[tmpLen]='\0';
	return 0;
}

/**
 *unsigned char* 转换成16进制字符串
 */
int byteToHex(unsigned char* puc,char* pc,int uclength)
{
	for (int i=0; i<uclength; i++) {
		char hex1;
		char hex2;
		
		int value=puc[i];
		int v1=value/16;
		int v2=value%16;
		
		if (v1>=0&&v1<=9) 
		{
			hex1=(char)(48+v1);
		}else {
			hex1=(char)(55+v1);
		}
		
		if (v2>=0&&v2<=9) 
		{
			hex2=(char)(48+v2);
		}else {
			hex2=(char)(55+v2);
		}
		pc[2*i]=hex1;
		pc[2*i+1]=hex2;
		
	}
	return 0;
}

/**
 *16进制字符串 转char*数组
 */
int hexStrTobyte(char* hexStr,char* outbuf)
{
	int len=(int)strlen(hexStr);

	char rs[3];
	memset(rs,0,sizeof(rs));
	
	for (int i=0; i<len/2; i++) 
	{
		rs[0]=hexStr[2*i];
		rs[1]=hexStr[2*i+1];
		char *stop;
		int num=(int)strtol((const char*)&rs, &stop, 16);
		outbuf[i]=(char)num;
	}
	
	return 0;
}


#pragma =====================扩展
/**
 *char*字符串 3des加密方法
 */
unsigned int desedeEncodeKey(char* inbuf,char* outbuf,int inputlen,char* key)
{
    return DESede_Encrypt(outbuf,inbuf,inputlen,key);
}

/**
 *char*字符串 3des解密方法
 */
unsigned int desedeDecodeKey(char* inbuf,char* outbuf,int inputlen,char* key)
{
    int tmpLen=DESede_Decrypt(outbuf,inbuf,inputlen,key);
	outbuf[tmpLen]='\0';
	return 0;
}
