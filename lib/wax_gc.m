/*
 *  wax_gc.c
 *  SQLite
 *
 *  Created by Corey Johnson on 11/10/09.
 *  Copyright 2009 Probably Interactive. All rights reserved.
 *
 */

#include "wax_gc.h"

#import "wax.h"
#import "wax_instance.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

static int __gc(lua_State *L);
static int __index(lua_State *L);
static int make(lua_State *L);

static const struct luaL_Reg MetaMethods[] = {
    {"__gc", __gc},
    {"__index", __index},
    {NULL, NULL}
};

static const struct luaL_Reg Methods[] = {
	{"make", make},
    {NULL, NULL}
};

int luaopen_wax_gc(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, WAX_GC_METATABLE_NAME);
    luaL_register(L, NULL, MetaMethods);
    luaL_register(L, WAX_GC_METATABLE_NAME, Methods);    
	    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}

static int make(lua_State *L) {
	wax_gc_create(L);
	return 1;
}

void wax_gc_create(lua_State *L) {
    BEGIN_STACK_MODIFY(L)
    
    size_t nbytes = sizeof(char*); // Don't really care about this object, just use it to collect the garbage!
    lua_newuserdata(L, nbytes);
	
    // set the metatable
    luaL_getmetatable(L, WAX_GC_METATABLE_NAME);
    lua_setmetatable(L, -2);

	lua_pop(L, 1); // Remove it from the stack! It will not get collected
	
    END_STACK_MODIFY(L, 0)
}
	
static int __index(lua_State *L) {
	NSLog(@"HIT!");
	return 0;
}

static int __gc(lua_State *L) {
	lua_gc(L, LUA_GCSTOP, 0);

	NSLog(@"GARBAGE COLLECTING");
	
	BEGIN_STACK_MODIFY(L)
		
	lua_newtable(L); // Stores which objects need to be removed from the userdataTable
	wax_instance_pushUserdataTable(L);

	// Go through each object in the userdata table
	lua_pushnil(L); // First key
	while (lua_next(L, 3)) {
		if (!lua_islightuserdata(L, -2)) {
			lua_pop(L, 1);
			continue;
		}
		
		wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, -1, WAX_INSTANCE_METATABLE_NAME);
		lua_pop(L, 1); // pops the value, keeps the key for next iteration
		
		if (!instanceUserdata->isClass && !instanceUserdata->isSuper && [instanceUserdata->instance retainCount] <= 1) {
			wax_log(LOG_GC, @"Removing userdata for instance for %@(%p -> %p)", [instanceUserdata->instance class], instanceUserdata->instance, instanceUserdata);
			lua_pushvalue(L, -1); // Copy key
			lua_rawseti(L, 2, lua_objlen(L, 2) + 1); // Store the key!
		}		
	}
	
	// Now remove all the unused userdata
	lua_pushnil(L);
	while (lua_next(L, 2)) {
		lua_pushnil(L);
		lua_rawset(L, 3);
	}
    
	// Create a new gc object for continued cleanup!
	wax_gc_create(L);
	
    END_STACK_MODIFY(L, 0)
	
	lua_gc(L, LUA_GCRESTART, 0);
	
    return 0;
}