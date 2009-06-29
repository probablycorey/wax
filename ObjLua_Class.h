//
//  ObjLua_Class.h
//  Lua
//
//  Created by ProbablyInteractive on 5/20/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

#define OBJLUA_CLASS_METATABLE_NAME "Objective-C.objlua.class"

typedef struct ObjLua_Class {
    Class objcClass;
} ObjLua_Class;

int luaopen_objlua_class(lua_State *L);
static int class(lua_State *L);
