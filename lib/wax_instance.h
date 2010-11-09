/*
 *  wax_instance.h
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

#define WAX_INSTANCE_METATABLE_NAME "wax.instance"

typedef struct _wax_instance_userdata {
    id instance;
    BOOL isClass;
    Class isSuper;
} wax_instance_userdata;

int luaopen_wax_instance(lua_State *L);

wax_instance_userdata *wax_instance_create(lua_State *L, id instance, BOOL isClass);
wax_instance_userdata *wax_instance_createSuper(lua_State *L, wax_instance_userdata *instanceUserdata);
void wax_instance_pushUserdataTable(lua_State *L);
void wax_instance_pushStrongUserdataTable(lua_State *L);

BOOL wax_instance_pushFunction(lua_State *L, id self, SEL selector);
void wax_instance_pushUserdata(lua_State *L, id object);
BOOL wax_instance_isWaxClass(id instance);