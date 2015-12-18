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
    gc_timeout: set wax_gc time interval, set -1 to stop gc.
    openBindOCFunction: then you can use C function list in extension/capi/bind/pkg
    mobdebug: then you can use lua debug tool like ZeroBraneStudio
 *  wax config. like luaSetWaxConfig({gc_timeout="1", openBindOCFunction="true", mobdebug="true"})
 */
int luaSetWaxConfig(lua_State *L);


NSDictionary *luaGetWaxConfig();
