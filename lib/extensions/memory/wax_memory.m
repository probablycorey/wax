//
// wax_lock.m
// wax
//
//  Created by junzhan on 14-5-22.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//

#import "wax_memory.h"
#import "wax.h"
#import "wax_class.h"
#import "wax_instance.h"
#import "wax_struct.h"
#import "wax_helpers.h"
#import "wax_gc.h"
#import "wax_server.h"
#import "wax_stdlib.h"

#import "lauxlib.h"
#import "lobject.h"
#import "lualib.h"
#import "wax_define.h"
//#import <Foundation/Foundation.h>

//x = &y. get address of object.
static int waxGetAddress(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    void *address = &instanceUserdata->instance;
    lua_pushlightuserdata(L, address);
    return 1;
}


//x = (long)y
static int waxGetInstancePointer(lua_State *L) {
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    long address = (long)instanceUserdata->instance;
    lua_pushnumber(L, address);
    return 1;
}

//*x = y.
static int waxDereference(lua_State *L) {
    void *leftData = lua_touserdata(L, 1);
    if(!leftData){
        return 0;
    }
    
    const char *type = lua_tostring(L, 2);
    void *rightData = nil;
    if(lua_isnil(L, 3)){
        rightData = nil;
    }else if(lua_isuserdata(L, 3)){
        wax_instance_userdata *rightInstance = (wax_instance_userdata *)luaL_checkudata(L, 3, WAX_INSTANCE_METATABLE_NAME);
        rightData = rightInstance->instance;
    }else if(lua_islightuserdata(L, 3)){
        rightData = lua_touserdata(L, 3);
    }
    
    if(0 == strcmp(type, "id")){//now it just support 'id'
        *((id*)leftData) = rightData;
    }
    return 0;
}


int luaopen_wax_memory(lua_State *L){
    
    lua_pushcfunction(L, waxGetAddress);
    lua_setglobal(L, "waxGetAddress");
    
    lua_pushcfunction(L, waxDereference);
    lua_setglobal(L, "waxDereference");
    
    lua_pushcfunction(L, waxGetInstancePointer);
    lua_setglobal(L, "waxGetInstancePointer");
    
    return 1;
}