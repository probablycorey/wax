//
// wax_lock.m
// wax
//
//  Created by junzhan on 14-5-22.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//

#import "wax_lock.h"
//#import <Foundation/Foundation.h>

NSRecursiveLock* wax_globalLock(){
    static NSRecursiveLock *globalLock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalLock = [[NSRecursiveLock alloc] init];
    });
    return globalLock;
}

//@interface WaxGlobalLock : NSObject
//
//+ (NSRecursiveLock *)waxGlobalLock;
//
//@end
//@implementation WaxGlobalLock
//
//+ (NSRecursiveLock *)waxGlobalLock{
//    return wax_globalLock();
//}
//@end
