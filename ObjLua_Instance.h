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

#define OBJLUA_METHOD_DEFINITION(_type_) _type_ OBJLUA_METHOD_NAME(_type_)(id self, SEL _cmd, ...)

#define OBJLUA_METHOD(_type_) \
OBJLUA_METHOD_DEFINITION(_type_) { \
va_list args; \
va_start(args, _cmd); \
va_list args_copy; \
va_copy(args_copy, args); \
/* Grab the static L... this is a hack */ \
lua_State *L = gL; \
int result = objlua_userdata_pcall(L, self, _cmd, args_copy); \
va_end(args_copy); \
va_end(args); \
if (result == -1) { \
    NSLog(@"ERROR!"); \
} \
else if (result == 1) { \
    NSMethodSignature *signature = [self methodSignatureForSelector:_cmd]; \
    _type_ *pReturnValue = (_type_ *)objlua_to_objc(L, [signature methodReturnType], -1); \
    _type_ returnValue = *pReturnValue; \
    free(pReturnValue); \
    return returnValue; \
} \
\
return (_type_)0; \
}


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

static int objlua_method_closure(lua_State *L);

OBJLUA_METHOD_DEFINITION(id);
OBJLUA_METHOD_DEFINITION(int);
OBJLUA_METHOD_DEFINITION(long);
OBJLUA_METHOD_DEFINITION(float);
OBJLUA_METHOD_DEFINITION(BOOL);