//
//  AutoTestRuntime.m
//  
//
//  Created by junzhan on 15-4-16.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "AutoTestRuntime.h"
#import "wax.h"
#include "lua.h"
#import "tolua++.h"
#import "AutoTestUtil.h"
#import <dispatch/queue.h>
#import <objc/message.h>
@implementation AutoTestRuntime

- (void)beforeAutoTestStart{
    lua_State *L = wax_currentLuaState();
    
    objc_setAssociatedObject(self, [self getKey1], @"value1", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    id value1 = objc_getAssociatedObject(self, [self getKey1]);
    NSLog(@"value=%@", value1);
    

    TOLUA_API int  tolua_objc_runtime_open (lua_State* tolua_S);
    tolua_objc_runtime_open(L);
    
    [AutoTestUtil runLuaFileInBundle:NSStringFromClass([self class])];
}

#pragma mark objc runtime

- (const void*)getKey1{
    static const char key1 = 'a';
    return &key1;
}
@end
