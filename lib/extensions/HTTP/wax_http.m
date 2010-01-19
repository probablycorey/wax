//
//    wax_http.m
//    Rentals
//
//    Created by ProbablyInteractive on 7/13/09.
//    Copyright 2009 Probably Interactive. All rights reserved.
//

#import "wax_http.h"
#import "wax_http_connection.h"
#import "wax_instance.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

const NSTimeInterval WAX_HTTP_TIMEOUT = 30;


static const struct luaL_Reg metaFunctions[] = {
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"request", request},
    {NULL, NULL}
};

int luaopen_wax_http(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, WAX_HTTP_METATABLE_NAME);        
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, WAX_HTTP_METATABLE_NAME, functions);    
    
    lua_pushvalue(L, -2);
    lua_setmetatable(L, -2); // Set the metatable for the module
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}

// wax.request(table) => returns connection object or (body, response) if syncronous
// wax.request{url, options} => returns  connection object or (body, response) if syncronous
// options:
//   method = "get" | "post" | "put" | "delete"
//   format = "text" | "binary" | "json"
//   timout = number
//   callback = function(body, response) # No callback? Then treat as syncronous
static int request(lua_State *L) {
    lua_rawgeti(L, 1, 1);
    
    NSString *urlString = [[NSString stringWithUTF8String:luaL_checkstring(L, -1)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    lua_pop(L, 1); // Pop the url off the stack
    
    if (!url) luaL_error(L, "wax_http: Could not create URL from string '%s'", [urlString UTF8String]);
    
    NSURLRequestCachePolicy cachePolicy = getCachePolicy(L, 1);
    NSDictionary *headerFields = [NSDictionary dictionary];
    NSData *body = [@"" dataUsingEncoding:NSUTF8StringEncoding];    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:WAX_HTTP_TIMEOUT];
        
    // Get the format
    int format = getFormat(L, 1);    
    NSTimeInterval timeout = getTimeout(L, 1);
    NSString *method = getMethod(L, 1);

    [urlRequest setAllHTTPHeaderFields:headerFields];
    [urlRequest setHTTPMethod:method];
    [urlRequest setHTTPBody:body];    
    [urlRequest setTimeoutInterval:timeout];

    wax_http_connection *connection = [[wax_http_connection alloc] initWithRequest:urlRequest luaState:L];
    [connection autorelease];
    connection.format = format;

    wax_instance_create(L, connection, NO);
    
    // Asyncronous or Syncronous
    if (pushCallback(L, 1)) { 
        lua_setfield(L, -2, WAX_HTTP_CALLBACK_FUNCTION_NAME); // Set the callback function for the userdata         

        [connection start];
        
        return 1; // Return the connectionDelegate as userdata
    }
    else {    
        [connection start];

        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];        
        while (!connection.finished) {
            [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
        }
        
        [connection release];

        return 2;
    }
}


static NSURLRequestCachePolicy getCachePolicy(lua_State *L, int tableIndex) {
    NSURLRequestCachePolicy cachePolicy = NSURLRequestUseProtocolCachePolicy;
    if (lua_isnoneornil(L, tableIndex)) return cachePolicy;
    
    lua_getfield(L, tableIndex, "cache");
    if (lua_isnumber(L, -1)) {
        cachePolicy = lua_tonumber(L, -1);
    }
    lua_pop(L, 1);
    
    return cachePolicy;
}

static NSTimeInterval getTimeout(lua_State *L, int tableIndex) {
    NSTimeInterval timeout = WAX_HTTP_TIMEOUT; // Default
    if (lua_isnoneornil(L, tableIndex)) return timeout;
    
    lua_getfield(L, tableIndex, "timeout");
    if (lua_isnumber(L, -1)) {
        timeout = lua_tonumber(L, -1);
    }
    lua_pop(L, 1);
    
    return timeout;
}

static NSString *getMethod(lua_State *L, int tableIndex) {
    NSString *method = @"GET"; // Default
    if (lua_isnoneornil(L, tableIndex)) return method;

    lua_getfield(L, tableIndex, "method");
    if (lua_isnumber(L, -1)) {
        method = [NSString stringWithUTF8String:lua_tostring(L, -1)];
    }
    lua_pop(L, 1);
    
    return method;
}

static int getFormat(lua_State *L, int tableIndex) {
    int format = WAX_HTTP_UNKNOWN; // Default
    if (lua_isnoneornil(L, tableIndex)) return format;

    lua_getfield(L, tableIndex, "format");
    if (lua_isstring(L, -1)) {
        const char *formatString = lua_tostring(L, -1);
        if (strcasecmp(formatString, "text") == 0) {
            format = WAX_HTTP_TEXT;
        }
        else if (strcasecmp(formatString, "binary") == 0) {
            format = WAX_HTTP_BINARY;
        }
        else if (strcasecmp(formatString, "json") == 0) {
            format = WAX_HTTP_JSON;
        }
        else {
            luaL_error(L, "wax_http: Unknown format name '%s'", formatString);
        }
    }
    lua_pop(L, 1);  
    
    return format;
}

// Assumes table is on top of the stack
static BOOL pushCallback(lua_State *L, int tableIndex) {
    lua_getfield(L, tableIndex, "callback");

    if (lua_isnil(L, -1)) {
        lua_pop(L, 1);
        return NO;
    }
    else {
        return YES;
    }
}