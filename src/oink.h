//
//  oink.h
//  Lua
//
//  Created by ProbablyInteractive on 5/27/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

void oink_start();
void oink_startWithExtensions(lua_CFunction func, ...);
void oink_end();

lua_State *oink_currentLuaState();

void luaopen_oink(lua_State *L);

static void addGlobals(lua_State *L);

static int tolua(lua_State *L);
static int toobjc(lua_State *L);
static int exitApp(lua_State *L);
static int objcDebug(lua_State *L);
