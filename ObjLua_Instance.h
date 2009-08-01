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

#import <MapKit/MapKit.h>

#import "lua.h"

#define OBJLUA_INSTANCE_METATABLE_NAME "objlua.instance"

typedef struct _ObjLua_Instance {
    id objcInstance;
    BOOL isClass;
} ObjLua_Instance;

int luaopen_objlua_instance(lua_State *L);

ObjLua_Instance *objlua_instance_create(lua_State *L, id objcInstance, BOOL isClass);
BOOL objlua_instance_push_function(lua_State *L, id self, SEL selector);
void objlua_instance_push_userdata(lua_State *L, id object);

static int __index(lua_State *L);
static int __newindex(lua_State *L);
static int __gc(lua_State *L);
static int __tostring(lua_State *L);
static int __call(lua_State *L);

int set_protocols(lua_State *L);

static int method_closure(lua_State *L);
static int super_closure(lua_State *L);
static BOOL override_method(lua_State *L, ObjLua_Instance *objLuaInstance);
static int userdata_pcall(lua_State *L, id self, SEL selector, va_list args);