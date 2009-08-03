//
//  ObjLua.h
//  Lua
//
//  Created by ProbablyInteractive on 5/27/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

void objlua_start();
void objlua_startWithExtensions(lua_CFunction func, ...);
void objlua_end();

lua_State *current_lua_state();

void luaopen_objlua(lua_State *L);

static void addGlobals(lua_State *L);

static int tolua(lua_State *L);
static int exitApp(lua_State *L);
static int objcDebug(lua_State *L);
