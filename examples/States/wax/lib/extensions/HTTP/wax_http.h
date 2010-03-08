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

static int request(lua_State *L);
static BOOL pushAuthCallback(lua_State *L, int tableIndex);
static BOOL pushCallback(lua_State *L, int table_index);
static int getFormat(lua_State *L, int tableIndex);
static NSDictionary *getHeaders(lua_State *L, int tableIndex);
static NSString *getMethod(lua_State *L, int tableIndex);
static NSURLRequestCachePolicy getCachePolicy(lua_State *L, int tableIndex);
static NSTimeInterval getTimeout(lua_State *L, int tableIndex);
static NSString *getBody(lua_State *L, int tableIndex);
