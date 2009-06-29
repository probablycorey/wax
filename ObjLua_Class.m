//
//  ObjLua_Class.m
//  Lua
//
//  Created by ProbablyInteractive on 5/20/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "ObjLua_Class.h"
#import "ObjLua_Instance.h"
#import "ObjLua_Helpers.h"

#import "lua.h"
#import "lauxlib.h"


static const struct luaL_Reg MetaMethods[] = {
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
    {"class", class},
    {NULL, NULL}
};

int luaopen_objlua_class(lua_State *L) {
    luaL_newmetatable(L, OBJLUA_CLASS_METATABLE_NAME);
    luaL_register(L, NULL, MetaMethods);
    luaL_register(L, "objlua", Methods);    

    return 1;
}


static int class(lua_State *L) {
    const char *rawClassName = luaL_checkstring(L, 1);
    
    objlua_instance_create(L, objc_getClass(rawClassName), YES);
        
    return 1;
}