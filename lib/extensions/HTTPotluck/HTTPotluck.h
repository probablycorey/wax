//
//    HTTPotluck.h
//    Rentals
//
//    Created by ProbablyInteractive on 7/13/09.
//    Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

#define HTTPOTLUCK_METATABLE_NAME "HTTPotluck"

int luaopen_HTTPotluck(lua_State *L);

static int request(lua_State *L);
static BOOL pushCallback(lua_State *L, int table_index);