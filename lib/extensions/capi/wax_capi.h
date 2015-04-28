//
// wax_capi.h
// wax
//
//  Created by junzhan on 14-9-12.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

id wax_objectFromLuaState(lua_State *L, int index);

void wax_openBindOCFunction(lua_State *L);