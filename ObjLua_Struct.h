//
//  ObjLua_Struct.h
//  Rentals
//
//  Created by ProbablyInteractive on 7/7/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

#define OBJLUA_STRUCT_METATABLE_NAME "objlua.struct"

int luaopen_objlua_struct(lua_State *L);

static int pack(lua_State *L);
static int __index(lua_State *L);

static int pack_closure(lua_State *L);