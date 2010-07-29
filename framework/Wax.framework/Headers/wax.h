//
//  wax.h
//  Lua
//
//  Created by ProbablyInteractive on 5/27/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

#define WAX_VERSION 0.9

void wax_setup();
void wax_start();
void wax_startWithExtensions(lua_CFunction func, ...);
void wax_startWithServer();
void wax_end();

lua_State *wax_currentLuaState();

void luaopen_wax(lua_State *L);