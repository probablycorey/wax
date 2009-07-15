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
    {"new", new},
    {"get", get},
    {NULL, NULL}
};

int luaopen_objlua_class(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, OBJLUA_CLASS_METATABLE_NAME);
    luaL_register(L, NULL, MetaMethods);
    luaL_register(L, "objlua.class", Methods);    

    END_STACK_MODIFY(L, 0);
    
    return 1;
}

// I don't like the name of this!
static int get(lua_State *L) {
    const char *rawClassName = luaL_checkstring(L, 1);
    objlua_instance_create(L, objc_getClass(rawClassName), YES);
        
    return 1;
}

static int new(lua_State *L) {
    const char *rawClassName = luaL_checkstring(L, 1);
    Class class = objc_getClass(rawClassName);
  
    Class superClass;    
    if (lua_isuserdata(L, 2)) {
        ObjLua_Instance *objLuaInstance = (ObjLua_Instance *)luaL_checkudata(L, 2, OBJLUA_INSTANCE_METATABLE_NAME);
        superClass = objLuaInstance->objcInstance;
    }
    else {
        const char *rawSuperClassName = luaL_checkstring(L, 2);    
        superClass = objc_getClass(rawSuperClassName);
    }
    
    if (!class) {
        class = objc_allocateClassPair(superClass, rawClassName, 0);
        objc_registerClassPair(class);        
    }        
        
    objlua_instance_create(L, class, YES);
    
    return 1;
}
