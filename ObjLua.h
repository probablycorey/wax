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
void objlua_end();

lua_State *current_lua_state();

void luaopen_objlua(lua_State *L);
