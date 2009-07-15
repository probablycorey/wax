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

typedef struct ObjLua_Struct {
    void *data;
    int size;
    char *typeDescription;
} ObjLua_Struct;


int luaopen_objlua_struct(lua_State *L);

ObjLua_Struct *objlua_struct_create(lua_State *L, char *typeDescription, void *buffer, int size);
int objlua_struct_refresh(lua_State *L, int stackindex);

static int __index(lua_State *L);
static int __newindex(lua_State *L);

static int pack(lua_State *L);

static int pack_closure(lua_State *L);