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

static int request(lua_State *L);

static BOOL pushCallback(lua_State *L, char *callbackName, int table_index);

static int getFormat(lua_State *L, int tableIndex);
static NSURLRequestCachePolicy getCachePolicy(lua_State *L, int tableIndex);
static NSDictionary *getHeaders(lua_State *L, int tableIndex);
static NSString *getMethod(lua_State *L, int tableIndex);
static NSTimeInterval getTimeout(lua_State *L, int tableIndex);
static NSString *getBody(lua_State *L, int tableIndex);

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
    
    return 0;
}

// wax.request({url, options}) => returns connection object or (body, response) if syncronous
// wax.request{url, options}   => same as above, but with syntax sugar
// options:
//   method = "get" | "post" | "put" | "delete"
//   format = "text" | "binary" | "json" | "xml" # if none given, uses value from response Content-Type Header
//   headers = table # Table of header values
//   timout = number
//   body = string
//   cache = NSURLRequestCachePolicy # one of those enums, defaults to NSURLRequestUseProtocolCachePolicy
//   callback = function(body, response) # No callback? Then treat request is treated as syncronous
//   progressCallback = function(percentComplete, data) # Shows how much is left to download
//   authCallback = function(NSURLAuthenticationChallenge) # Handle just like you would with NSURLConnection
//   redirectCallback = function(response) # If there is a redirect, this callback will be called
static int request(lua_State *L) {
    lua_rawgeti(L, 1, 1);
    
    NSString *urlString = [NSString stringWithUTF8String:luaL_checkstring(L, -1)];
    if (![urlString hasPrefix:@"http://"] && ![urlString hasPrefix:@"https://"]) urlString = [NSString stringWithFormat:@"http://%@", urlString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    lua_pop(L, 1); // Pop the url off the stack
    
    if (!url) luaL_error(L, "wax_http: Could not create URL from string '%s'", [urlString UTF8String]);
          
    
    NSURLRequestCachePolicy cachePolicy = getCachePolicy(L, 1);
    NSDictionary *headerFields = getHeaders(L, 1);
    NSData *body = [getBody(L, 1) dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get the format
    int format = getFormat(L, 1);    
    NSTimeInterval timeout = getTimeout(L, 1);
    NSString *method = getMethod(L, 1);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];

	[urlRequest setHTTPMethod:method];
    [urlRequest setCachePolicy:cachePolicy];
    [urlRequest setAllHTTPHeaderFields:headerFields];
    [urlRequest setHTTPBody:body];
    
    wax_http_connection *connection;
    connection = [[[wax_http_connection alloc] initWithRequest:urlRequest timeout:timeout luaState:L] autorelease]; 
    connection.format = format;
    [urlRequest release];
    
    wax_instance_create(L, connection, NO);

	if (pushCallback(L, WAX_HTTP_AUTH_CALLBACK_FUNCTION_NAME, 1)) {
		lua_setfield(L, -2, WAX_HTTP_AUTH_CALLBACK_FUNCTION_NAME); // Set the authCallback function for the userdata         
	}

	if (pushCallback(L, WAX_HTTP_PROGRESS_CALLBACK_FUNCTION_NAME, 1)) {
		lua_setfield(L, -2, WAX_HTTP_PROGRESS_CALLBACK_FUNCTION_NAME); // Set the progressCallback function for the userdata         
	}	

	if (pushCallback(L, WAX_HTTP_REDIRECT_CALLBACK_FUNCTION_NAME, 1)) {
		lua_setfield(L, -2, WAX_HTTP_REDIRECT_CALLBACK_FUNCTION_NAME); // Set the redirectCallback function for the userdata         
	}		
	
    // Asyncronous or Syncronous
    if (pushCallback(L, WAX_HTTP_CALLBACK_FUNCTION_NAME, 1)) { 
        lua_setfield(L, -2, WAX_HTTP_CALLBACK_FUNCTION_NAME); // Set the callback function for the userdata         

        [connection start];
        
        return 1; // Return the connectionDelegate as userdata
    }
    else {    
        [connection start];

        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];        
        while (!connection.finished) {
            [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        }
        
        return 3;
    }
}

static NSTimeInterval getTimeout(lua_State *L, int tableIndex) {
    NSTimeInterval timeout = WAX_HTTP_TIMEOUT; // Default
    if (lua_isnoneornil(L, tableIndex)) return timeout;
    
    lua_getfield(L, tableIndex, "timeout");
    if (!lua_isnil(L, -1)) {
        timeout = luaL_checknumber(L, -1);
    }
    lua_pop(L, 1);
    
    return timeout;
}

static NSDictionary *getHeaders(lua_State *L, int tableIndex) {
    NSDictionary *headers = [NSDictionary dictionary];
    
    if (lua_isnoneornil(L, tableIndex)) return headers;

    lua_getfield(L, tableIndex, "headers");
    if (!lua_isnil(L, -1)) {
        id *result = wax_copyToObjc(L, "@", -1, nil);
        headers = *result;
        free(result);
    }
    lua_pop(L, 1);
    
    return headers;
}

static NSString *getMethod(lua_State *L, int tableIndex) {
    NSString *method = @"GET"; // Default
    if (lua_isnoneornil(L, tableIndex)) return method;

    lua_getfield(L, tableIndex, "method");
    if (!lua_isnil(L, -1)) {
        const char *string = luaL_checkstring(L, -1);
        method = [[NSString stringWithUTF8String:string] uppercaseString];
    }
    lua_pop(L, 1);
    
    return method;
}

static NSURLRequestCachePolicy getCachePolicy(lua_State *L, int tableIndex) {
    NSURLRequestCachePolicy cachePolicy = NSURLRequestUseProtocolCachePolicy;
    if (lua_isnoneornil(L, tableIndex)) return cachePolicy;
    
    lua_getfield(L, tableIndex, "cache");
    if (!lua_isnil(L, -1)) {
        cachePolicy = luaL_checknumber(L, -1);
    }
    lua_pop(L, 1);
    
    return cachePolicy;
}

static int getFormat(lua_State *L, int tableIndex) {
    int format = WAX_HTTP_UNKNOWN; // Default
    if (lua_isnoneornil(L, tableIndex)) return format;

    lua_getfield(L, tableIndex, "format");
    if (!lua_isnil(L, -1)) {
        const char *formatString = luaL_checkstring(L, -1);
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

static NSString *getBody(lua_State *L, int tableIndex) {
    NSString *body = @""; // Default
    if (lua_isnoneornil(L, tableIndex)) return body;
    
    lua_getfield(L, tableIndex, "body");
    if (!lua_isnil(L, -1)) {
        const char *string = luaL_checkstring(L, -1);
        body = [NSString stringWithUTF8String:string];
    }
    lua_pop(L, 1);
    
    return body;
}

// Assumes table is on top of the stack
static BOOL pushCallback(lua_State *L, char *callbackName, int tableIndex) {
    lua_getfield(L, tableIndex, callbackName);

    if (lua_isnil(L, -1)) {
        lua_pop(L, 1);
        return NO;
    }
    else {
        return YES;
    }
}