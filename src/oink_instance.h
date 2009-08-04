/*
 *  oink_instance.h
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

#define OINK_INSTANCE_METATABLE_NAME "oink.instance"

typedef struct _oink_instance_userdata {
    id instance;
    BOOL isClass;
    BOOL isSuper;
} oink_instance_userdata;

int luaopen_oink_instance(lua_State *L);

oink_instance_userdata *oink_instance_create(lua_State *L, id instance, BOOL isClass);
oink_instance_userdata *oink_instance_createSuper(lua_State *L, oink_instance_userdata *instanceUserdata);

BOOL oink_instance_pushFunction(lua_State *L, id self, SEL selector);
void oink_instance_pushUserdata(lua_State *L, id object);

static int __index(lua_State *L);
static int __newindex(lua_State *L);
static int __gc(lua_State *L);
static int __tostring(lua_State *L);
static int __eq(lua_State *L);

int setProtocols(lua_State *L);

static int methodClosure(lua_State *L);
static int superMethodClosure(lua_State *L);
static int customInitMethodClosure(lua_State *L);
    
static BOOL overrideMethod(lua_State *L, oink_instance_userdata *instanceUserdata);
static int pcallUserdata(lua_State *L, id self, SEL selector, va_list args);