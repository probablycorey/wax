//
//  wax_define.h
// wax
//
//  Created by junzhan on 15-1-8.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//


typedef long long LongLong;

/**
 *  original method prefix in lua call
 */
#define WAX_ORIGINAL_METHOD_PREFIX "ORIG"

/**
 *  wax replace method prefix
 *
 */
#define WAX_REPLACE_METHOD_PREFIX "WAXORIG"

/**
 *  super method prefix
 */
#define WAX_SUPER_METHOD_PREFIX "SUPER"

/**
 *  support method with '_'. [self _aaa_bbb:v1 __cc_:v2] -> self:UNDERxLINEaaaUNDERxLINEbbb_UNDERxLINEUNDERxLINEccUNDERxLINE(v1, v2)
 */
#define WAX_METHOD_UNDER_LINE_MARK "UNDERxLINE"

/**
 *  support method with '$'. [self $aaa$bbb:v1 $$cc$:v2] -> self:DOLLARxMARKaaaDOLLARxMARKbbb_DOLLARxMARKDOLLARxMARKccDOLLARxMARK(v1, v2)
 */
#define WAX_METHOD_DOLLAR_MARK "DOLLARxMARK"

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
//    #warning @"64 bit arm"
    #define WAX_IS_ARM_64 1
#else
    #define WAX_IS_ARM_64 0
//    #warning @"32 bit arm"
#endif