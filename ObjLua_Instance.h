/*
 *  ObjLua_Instance.h
 *  Lua
 *
 *  Created by ProbablyInteractive on 5/18/09.
 *  Copyright 2009 Probably Interactive. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "lua.h"

#define OBJLUA_INSTANCE_METATABLE_NAME "Objective-C.objlua.instance"

typedef struct ObjLua_Instance {
    id objcInstance;
    BOOL isClass;
} ObjLua_Instance;

int luaopen_objlua_instance(lua_State *L);
ObjLua_Instance *objlua_instance_create(lua_State *L, id objcInstance, BOOL isClass);

static int __index(lua_State *L);
static int __newindex(lua_State *L);
static int __gc(lua_State *L);
static int __tostring(lua_State *L);

static int methodClosure(lua_State *L);