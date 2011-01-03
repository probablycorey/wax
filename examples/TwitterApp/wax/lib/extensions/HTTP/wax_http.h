//
//    wax_http.h
//    Rentals
//
//    Created by ProbablyInteractive on 7/13/09.
//    Copyright 2009 Probably Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lua.h"

#define WAX_HTTP_METATABLE_NAME "wax.http"

int luaopen_wax_http(lua_State *L);