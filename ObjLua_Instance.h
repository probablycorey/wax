/*
 *  ObjLua_Instance.h
 *  Lua
 *
 *  Created by ProbablyInteractive on 5/18/09.
 *  Copyright 2009 Probably Interactive. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import "lua.h"

#define OBJLUA_INSTANCE_METATABLE_NAME "objlua.instance"
#define OBJLUA_METHOD_NAME(_type_) objlua_##_type_##_call
#define OBJLUA_METHOD_DEFINITION(_type_) static _type_ OBJLUA_METHOD_NAME(_type_)(id self, SEL _cmd, ...)

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

int set_protocols(lua_State *L);

static int method_closure(lua_State *L);
static BOOL override_method(lua_State *L, ObjLua_Instance *objLuaInstance);
static int userdata_pcall(lua_State *L, id self, SEL selector, va_list args);

BOOL push_function_for_instance(lua_State *L, id self, SEL selector);
void push_userdata_for_instance(lua_State *L, id object);

OBJLUA_METHOD_DEFINITION(id);
OBJLUA_METHOD_DEFINITION(int);
OBJLUA_METHOD_DEFINITION(long);
OBJLUA_METHOD_DEFINITION(float);
OBJLUA_METHOD_DEFINITION(BOOL);