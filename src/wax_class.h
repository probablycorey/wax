//
//  oink_class.h
//  Lua
//
//  Created by ProbablyInteractive on 5/20/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import "lua.h"

#define OINK_CLASS_METATABLE_NAME "oink.class"

typedef struct _oink_class {
    Class objcClass;
} oink_class;

int luaopen_oink_class(lua_State *L);
static int __index(lua_State *L);
static int __call(lua_State *L);

static int addProtocols(lua_State *L);