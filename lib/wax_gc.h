/*
 *  wax_gc.h
 *  SQLite
 *
 *  Created by Corey Johnson on 11/10/09.
 *  Copyright 2009 Probably Interactive. All rights reserved.
 *
 */

#import "lua.h"
#import "wax_conf.h"

#define WAX_GC_METATABLE_NAME "wax.gc"

int luaopen_wax_gc(lua_State *L);
void wax_gc_create(lua_State *L);