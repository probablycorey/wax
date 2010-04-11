//
//    wax_http_connection.m
//    RentList
//
//    Created by Corey Johnson on 8/9/09.
//    Copyright 2009 ProbablyInteractive. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>

#import "lauxlib.h"

#import "wax_http_connection.h"
#import "wax_instance.h"
#import "wax_helpers.h"
#import "wax_json.h"
#import "wax_xml.h"

@implementation wax_http_connection

@synthesize response=_response;
@synthesize format=_format;
@synthesize finished=_finished;

- (void)dealloc {
    [_data release];
    [_response release];
    [_request release];
    [super dealloc];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest luaState:(lua_State *)luaState {
    [super initWithRequest:urlRequest delegate:self startImmediately:NO];
    [self scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    L = luaState;

    _data = [[NSMutableData alloc] init];
    _request = [urlRequest retain];

    _format = WAX_HTTP_UNKNOWN;
    _error = NO;
    _canceled = NO;
    return self;
}

- (void)start {
    wax_log(LOG_DEBUG, @"HTTP(%@) %@", [_request HTTPMethod], [_request URL]);
    [super start];
}

- (void)cancel {
    _canceled = YES;
    [super cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (response != _response) [_response release];
    _response = [response retain];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (![self callLuaAuthCallback:challenge]) {
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (!_canceled) {
        _error = YES;
        [_data release];
        _data = [[error localizedDescription] retain];
        [self callLuaCallback];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!_canceled) {
        [self callLuaCallback];
    }
}

- (BOOL)callLuaAuthCallback:(NSURLAuthenticationChallenge *)challenge { 
    BEGIN_STACK_MODIFY(L)
    
    if (_canceled) {
        assert("OH NO, URL CONNECTION WAS CANCELED BUT NOT CAUGHT");
    }
    
    wax_instance_pushUserdata(L, self);
    lua_getfield(L, -1, WAX_HTTP_AUTH_CALLBACK_FUNCTION_NAME);
    
    bool hasCallback = YES;
    if (lua_isnil(L, -1)) { 
        hasCallback = NO;
        lua_pop(L, 1);
    }
    
    wax_fromObjc(L, "@", &challenge);
    
    if (hasCallback && wax_pcall(L, 1, 0)) {
        const char* error_string = lua_tostring(L, -1);
        printf("Problem calling Lua function '%s' from wax_http.\n%s", WAX_HTTP_AUTH_CALLBACK_FUNCTION_NAME, error_string);
    }
    
    END_STACK_MODIFY(L, 0)
    
    return hasCallback;
}


- (void)callLuaCallback { 
    BEGIN_STACK_MODIFY(L)
    
    if (_canceled) {
        assert("OH NO, URL CONNECTION WAS CANCELED BUT NOT CAUGHT");
    }
    
    wax_instance_pushUserdata(L, self);
    lua_getfield(L, -1, WAX_HTTP_CALLBACK_FUNCTION_NAME);
    
    bool hasCallback = YES;
    if (lua_isnil(L, -1)) { 
        hasCallback = NO;
        lua_pop(L, 1);
    }
    
    // Try and guess the format type
    if (_format == WAX_HTTP_UNKNOWN) {
        NSString *contentType = [[_response allHeaderFields] objectForKey:@"Content-Type"];

        if ([contentType hasPrefix:@"application/xml"] ||
            [contentType hasPrefix:@"text/xml"]) {
            _format = WAX_HTTP_XML;
        }
        else if ([contentType hasPrefix:@"application/json"] ||
                 [contentType hasPrefix:@"text/json"] ||
                 [contentType hasPrefix:@"application/javascript"] ||
                 [contentType hasPrefix:@"text/javascript"]) {
            _format = WAX_HTTP_JSON;
        }
        else if ([contentType hasPrefix:@"image/"] ||
                 [contentType hasPrefix:@"audio/"] ||
                 [contentType hasPrefix:@"application/octet-stream"]) {
            _format = WAX_HTTP_BINARY;
        }
        else {
            _format = WAX_HTTP_TEXT;
        }
    }
    
    if (_error) {
        lua_pushnil(L);
    }
    else if (_format == WAX_HTTP_TEXT || _format == WAX_HTTP_JSON || _format == WAX_HTTP_XML) {
        NSString *string = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
        
        if (_format == WAX_HTTP_JSON) {
            json_parseString(L, [string UTF8String]);            
        }
        else if (_format == WAX_HTTP_XML){
            wax_xml_parseString(L, [string UTF8String]);
        }
        else {
            wax_fromObjc(L, "@", &string);
        }

        
        [string release];
    }
    else if (_format == WAX_HTTP_BINARY) {        
        wax_fromObjc(L, "@", &_data);
    }
    else {
        luaL_error(L, "wax_http: Unknown wax_http format '%d'", _format);
    }
    
    wax_fromObjc(L, "@", &_response);
    wax_fromObjc(L, "@", &_data); // Send the raw data too (since oddly, the response doesn't contain it)
    
    if (hasCallback && wax_pcall(L, 3, 0)) {
        const char* error_string = lua_tostring(L, -1);
        printf("Problem calling Lua function '%s' from wax_http.\n%s", WAX_HTTP_CALLBACK_FUNCTION_NAME, error_string);
    }
    
    _finished = YES;
    
    END_STACK_MODIFY(L, 3)
}

@end
