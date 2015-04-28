//
// wax_config.h
// wax
//
//  Created by junzhan on 14-9-25.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"


/**
 *  wax config. like luaSetWaxConfig({wax_gc_timeout="1"})
 */
int luaSetWaxConfig(lua_State *L);
