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

static int request(lua_State *L) {
    lua_rawgeti(L, 1, 1);
    
    NSString *urlString = [[NSString stringWithCString:luaL_checkstring(L, -1)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (!url) luaL_error(L, "HTTPotluck: Could not create URL from string '%s'", [urlString UTF8String]);

    #ifdef DEBUG
        //NSLog(@"HTTPotluck: GET %@", url);
    #endif
    
    NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    NSDictionary *headerFields = [NSDictionary dictionary];
    NSString *method = @"GET";
    NSData *body = [@"" dataUsingEncoding:NSUTF8StringEncoding];    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:HTTPOTLUCK_TIMEOUT];
        
    // Get the format
    int format = HTTPOTLUCK_TEXT;
    lua_getfield(L, 1, "format");
    if (lua_isstring(L, -1)) {
        const char *formatString = lua_tostring(L, -1);
        if (strcasecmp(formatString, "text") == 0) {
            format = HTTPOTLUCK_TEXT;
        }
        else if (strcasecmp(formatString, "binary") == 0) {
            format = HTTPOTLUCK_BINARY;
        }
        else {
            luaL_error(L, "HTTPotluck: Unknown format name '%s'", formatString);
        }
    }
    lua_pop(L, 1); // Pop off format info

    NSTimeInterval timeout = HTTPOTLUCK_TIMEOUT;
    lua_getfield(L, 1, "timeout");
    if (lua_isnumber(L, -1)) {
        timeout = lua_tonumber(L, -1);
    }
    lua_pop(L, 1); // Pop off format info
    
    [urlRequest setAllHTTPHeaderFields:headerFields];
    [urlRequest setHTTPMethod:method];
    [urlRequest setHTTPBody:body];    
    [urlRequest setTimeoutInterval:timeout];
    
    // Asyncronous or Syncronous
    if (pushCallback(L, 1)) { 
        HTTPotluck_connection *connection = [[HTTPotluck_connection alloc] initWithRequest:urlRequest luaState:L];
        wax_instance_create(L, connection, NO);

        lua_insert(L, -2); // Move the callback function to the top of the stack
        lua_setfield(L, -2, HTTPOTLUCK_CALLBACK_FUNCTION_NAME); // Set the callback function for the userdata 
        
        connection.format = format;
        [connection start];

        return 1; // Return the connectionDelegate as userdata
    }
    else {    
    // Syncronous and async code should be combined!
    
        NSError *error = nil;    
        NSHTTPURLResponse *urlResponse = nil;    
        body = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];    
        [urlRequest release];
    
        // Body
        NSString *bodyString = [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease];
        lua_pushstring(L, [bodyString UTF8String]);

        // Push the HTTPResponse
        wax_fromObjc(L, "@", &urlResponse);

        return 2;
    }
}

// Assumes table is on top of the stack
static BOOL pushCallback(lua_State *L, int table_index) {
    lua_getfield(L, table_index, "callback");

    if (lua_isnil(L, -1)) {
        lua_pop(L, 1);
        return NO;
    }
    else {
        return YES;
    }
}
