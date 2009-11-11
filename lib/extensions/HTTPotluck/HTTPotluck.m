//
//    HTTPotluck.m
//    Rentals
//
//    Created by ProbablyInteractive on 7/13/09.
//    Copyright 2009 Probably Interactive. All rights reserved.
//

#import "HTTPotluck.h"
#import "HTTPotluck_connection.h"
#import "wax_instance.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

const NSTimeInterval HTTPOTLUCK_TIMEOUT = 30;


static const struct luaL_Reg metaFunctions[] = {
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"request", request},
    {NULL, NULL}
};

int luaopen_HTTPotluck(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, HTTPOTLUCK_METATABLE_NAME);        
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, HTTPOTLUCK_METATABLE_NAME, functions);    
    
    lua_pushvalue(L, -2);
    lua_setmetatable(L, -2); // Set the metatable for the module
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}

// request(table) => connection object or (body, response) if syncronous
// request{url, options} => connection object or (body, response) if syncronous
// options:
//   method = *"get" | "post" | "put" | "delete"
//   format = *"text" | "binary" | "json"
//   timout = [number]
//   callback = function(body, response)
static int request(lua_State *L) {
    lua_rawgeti(L, 1, 1);
    
    NSString *urlString = [[NSString stringWithUTF8String:luaL_checkstring(L, -1)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    lua_pop(L, 1); // Pop the url off the stack
    
    if (!url) luaL_error(L, "HTTPotluck: Could not create URL from string '%s'", [urlString UTF8String]);
    
    NSURLRequestCachePolicy cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSDictionary *headerFields = [NSDictionary dictionary];
    NSData *body = [@"" dataUsingEncoding:NSUTF8StringEncoding];    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:HTTPOTLUCK_TIMEOUT];
        
    // Get the format
    int format = getFormat(L, 1);    
    NSTimeInterval timeout = getTimeout(L, 1);
    NSString *method = getMethod(L, 1);

    [urlRequest setAllHTTPHeaderFields:headerFields];
    [urlRequest setHTTPMethod:method];
    [urlRequest setHTTPBody:body];    
    [urlRequest setTimeoutInterval:timeout];

    HTTPotluck_connection *connection = [[HTTPotluck_connection alloc] initWithRequest:urlRequest luaState:L];
    connection.format = format;

    wax_instance_create(L, connection, NO);
    
    // Asyncronous or Syncronous
    if (pushCallback(L, 1)) { 
        lua_setfield(L, -2, HTTPOTLUCK_CALLBACK_FUNCTION_NAME); // Set the callback function for the userdata         

        [connection start];
        
        return 1; // Return the connectionDelegate as userdata
    }
    else {    
        [connection start];

        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];        
        while (!connection.finished) {
            [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
        }

        return 3;
    }
}

static NSTimeInterval getTimeout(lua_State *L, int tableIndex) {
    NSTimeInterval timeout = HTTPOTLUCK_TIMEOUT;
    if (lua_isnoneornil(L, tableIndex)) return timeout;
    
    lua_getfield(L, tableIndex, "timeout");
    if (lua_isnumber(L, -1)) {
        timeout = lua_tonumber(L, -1);
    }
    lua_pop(L, 1);
    
    return timeout;
}

static NSString *getMethod(lua_State *L, int tableIndex) {
    NSString *method = @"GET";
    if (lua_isnoneornil(L, tableIndex)) return method;

    lua_getfield(L, tableIndex, "method");
    if (lua_isnumber(L, -1)) {
        method = [NSString stringWithUTF8String:lua_tostring(L, -1)];
    }
    lua_pop(L, 1);
    
    return method;
}

static int getFormat(lua_State *L, int tableIndex) {
    int format = HTTPOTLUCK_UNKNOWN;
    if (lua_isnoneornil(L, tableIndex)) return format;

    lua_getfield(L, tableIndex, "format");
    if (lua_isstring(L, -1)) {
        const char *formatString = lua_tostring(L, -1);
        if (strcasecmp(formatString, "text") == 0) {
            format = HTTPOTLUCK_TEXT;
        }
        else if (strcasecmp(formatString, "binary") == 0) {
            format = HTTPOTLUCK_BINARY;
        }
        else if (strcasecmp(formatString, "json") == 0) {
            format = HTTPOTLUCK_JSON;
        }
        else {
            luaL_error(L, "HTTPotluck: Unknown format name '%s'", formatString);
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
