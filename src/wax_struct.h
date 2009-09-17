//
//  wax_struct.h
//  Rentals
//
//  Created by ProbablyInteractive on 7/7/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

#define WAX_STRUCT_METATABLE_NAME "wax.struct"

typedef struct _wax_struct_userdata {
    void *data;
    int size;
    char *name;
    char *typeDescription;
} wax_struct_userdata;

int luaopen_wax_struct(lua_State *L);

wax_struct_userdata *wax_struct_create(lua_State *L, const char *typeDescription, void *buffer);
void wax_struct_pushValueAt(lua_State *L, wax_struct_userdata *structUserdata, int index);
void wax_struct_setValueAt(lua_State *L, wax_struct_userdata *structUserdata, int index, int stackIndex);
int wax_struct_getOffsetForName(lua_State *L, wax_struct_userdata *structUserdata, const char *name);

static int __index(lua_State *L);
static int __newindex(lua_State *L);
static int __tostring(lua_State *L);

static int create(lua_State *L);
static int unpack(lua_State *L);
static int pack(lua_State *L);
    
static int createClosure(lua_State *L);