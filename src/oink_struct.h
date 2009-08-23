//
//  oink_struct.h
//  Rentals
//
//  Created by ProbablyInteractive on 7/7/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

#define OINK_STRUCT_METATABLE_NAME "oink.struct"

typedef struct _oink_struct_userdata {
    void *data;
    int size;
    char *typeDescription;
} oink_struct_userdata;

int luaopen_oink_struct(lua_State *L);

oink_struct_userdata *oink_struct_create(lua_State *L, const char *typeDescription, void *buffer);

static int __index(lua_State *L);
static int __newindex(lua_State *L);
static int __tostring(lua_State *L);

static int unpack(lua_State *L);
static int pack(lua_State *L);
static int packClosure(lua_State *L);