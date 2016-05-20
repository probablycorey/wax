//
// wax_capi.m
// wax
//
//  Created by junzhan on 14-9-12.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//

#import "wax_capi.h"
#import "wax.h"
#import "wax_class.h"
#import "wax_instance.h"
#import "wax_struct.h"
#import "wax_helpers.h"
#import "wax_block.h"
#import "tolua++.h"

id wax_objectFromLuaState(lua_State *L, int index){
    if(lua_isnil(L, index)){
        return nil;
    }else{
        id *instancePointer = wax_copyToObjc(L, "@", index, nil);
        id instance = *(id *)instancePointer;
        free(instancePointer);
        return instance;
    }
}

void wax_openBindOCFunction(lua_State *L){
    
#ifndef WAX_TARGET_OS_WATCH
    TOLUA_API int  tolua_UIKitFunction_open (lua_State* tolua_S);
    tolua_UIKitFunction_open(L);

#endif
    
    TOLUA_API int  tolua_objc_runtime_open (lua_State* tolua_S);
    tolua_objc_runtime_open(L);
    
    TOLUA_API int  tolua_dispatch_open (lua_State* tolua_S);
    tolua_dispatch_open (L);

    TOLUA_API int  tolua_pthread_open (lua_State* tolua_S);
    tolua_pthread_open(L);
}
