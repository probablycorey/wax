//
//  wax_class.h
//  Lua
//
//  Created by ProbablyInteractive on 5/20/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import "lua.h"

#define WAX_CLASS_METATABLE_NAME "wax.class"
#define WAX_CLASS_INSTANCE_USERDATA_IVAR_NAME "wax_instance_userdata"

int luaopen_wax_class(lua_State *L);
