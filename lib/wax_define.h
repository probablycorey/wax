//
//  wax_define.h
// wax
//
//  Created by junzhan on 15-1-8.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//


typedef long long LongLong;

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
#warning @"64 bit arm"
#define WAX_IS_ARM_64 1
#else
#define WAX_IS_ARM_64 0
#warning @"32 bit arm"
#endif


#ifdef DEBUG

#else

#define NSLog(...) {}

#endif