//
//  wax.h
//  Lua
//
//  Created by ProbablyInteractive on 5/27/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"
#import "wax_conf.h"

void wax_start();
void wax_startWithExtensions(lua_CFunction func, ...);
void wax_end();

lua_State *wax_currentLuaState();

void luaopen_wax(lua_State *L);

static void addGlobals(lua_State *L);

static int tolua(lua_State *L);
static int toobjc(lua_State *L);
static int exitApp(lua_State *L);
static int objcDebug(lua_State *L);
