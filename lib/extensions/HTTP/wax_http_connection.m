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

#ifdef WAX_XML_INCLUDED
#import "wax_xml.h"
#endif

@implementation wax_http_connection

@synthesize response=_response;
@synthesize format=_format;
@synthesize finished=_finished;

- (void)dealloc {
    [_data release];
    [_error release];
    [_response release];
    [_request release];
    [_timeoutTimer release];
    [super dealloc];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest timeout:(NSTimeInterval)timeout luaState:(lua_State *)luaState {
    self = [super initWithRequest:urlRequest delegate:self startImmediately:NO];
    [self scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    L = luaState;

    _data = [[NSMutableData alloc] init];
    _request = [urlRequest retain];

    _timeout = timeout;
    _format = WAX_HTTP_UNKNOWN;
    _canceled = NO;
    return self;
}

- (void)timeoutHack {
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:nil];
    [self connection:self didFailWithError:error];
    [self cancel];
}

- (void)start {
    // Apple makes has a mandatory 240 second minimum timeout WTF? https://devforums.apple.com/thread/25282
    // Because of this stupidity by Apple, we are forced to setup our own timeout
    // using a timer.
    _timeoutTimer = [[NSTimer scheduledTimerWithTimeInterval:_timeout target:self selector:@selector(timeoutHack) userInfo:nil repeats:NO] retain]; 
    wax_log(LOG_NETWORK, @"HTTP(%@) %@", [_request HTTPMethod], [_request URL]);
    [super start];
}

- (void)cancel {
	wax_log(LOG_NETWORK, @"CANCELING (%@) %@", [_request HTTPMethod], [_request URL]);
    [_timeoutTimer invalidate];
    _canceled = YES;
    [super cancel];
}

- (bool)isFinished {
	return _canceled || _finished;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (response != _response) [_response release];
    _response = [response retain];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	if (redirectResponse) [self callRedirectCallback:redirectResponse];
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (![self callLuaAuthCallback:challenge]) {
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
	[self callLuaProgressCallback];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (!_canceled) {
        _error = [error retain];
        [_data release];
        _data = nil;
        [self callLuaCallback];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!_canceled) {
        [self callLuaCallback];
    }
}

- (void)callRedirectCallback:(NSURLResponse *)redirectResponse {
	BEGIN_STACK_MODIFY(L)
    
    if (_canceled) {
        assert("OH NO, URL CONNECTION WAS CANCELED BUT NOT CAUGHT");
    }
    
    wax_instance_pushUserdata(L, self);
    lua_getfield(L, -1, WAX_HTTP_REDIRECT_CALLBACK_FUNCTION_NAME);
    
    bool hasCallback = YES;
    if (lua_isnil(L, -1)) { 
        hasCallback = NO;
        lua_pop(L, 1);
    }
    
    wax_fromObjc(L, "@", &redirectResponse);
    
    if (hasCallback && wax_pcall(L, 1, 0)) {
        const char* error_string = lua_tostring(L, -1);
        luaL_error(L, "Problem calling Lua function '%s' from wax_http.\n%s", WAX_HTTP_REDIRECT_CALLBACK_FUNCTION_NAME, error_string);
    }
    
    END_STACK_MODIFY(L, 0)
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
        luaL_error(L, "Problem calling Lua function '%s' from wax_http.\n%s", WAX_HTTP_AUTH_CALLBACK_FUNCTION_NAME, error_string);
    }
    
    END_STACK_MODIFY(L, 0)
    
    return hasCallback;
}

- (void)callLuaProgressCallback { 
    BEGIN_STACK_MODIFY(L)
    
    if (_canceled) {
        assert("OH NO, URL CONNECTION WAS CANCELED BUT NOT CAUGHT");
    }
    
    wax_instance_pushUserdata(L, self);
    lua_getfield(L, -1, WAX_HTTP_PROGRESS_CALLBACK_FUNCTION_NAME);
    
    if (lua_isnil(L, -1)) { 
        lua_pop(L, 1);
    }
	else {
		float percentComplete = 0;
		
		@try {
			percentComplete = _data.length / [[[_response allHeaderFields] objectForKey:@"Content-Length"] floatValue];
		}
		@catch (NSException * e) {
			NSLog(@"Error: Couldn't calculate percent Complete");
		}
		
		
		wax_fromObjc(L, "f", &percentComplete);
		wax_fromObjc(L, "@", &_data);
    
		if (wax_pcall(L, 2, 0)) {
			const char* error_string = lua_tostring(L, -1);
			luaL_error(L, "Problem calling Lua function '%s' from wax_http.\n%s", WAX_HTTP_PROGRESS_CALLBACK_FUNCTION_NAME, error_string);
		}
	}
    
    END_STACK_MODIFY(L, 0)
}


- (void)callLuaCallback { 
    [_timeoutTimer invalidate];
    
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
#ifdef WAX_XML_INCLUDED
            _format = WAX_HTTP_XML;
#else
			_format = WAX_HTTP_TEXT;
#endif
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
        if (!string) string = [[NSString alloc] initWithData:_data encoding:NSISOLatin1StringEncoding];
        if (!string) string = [[NSString alloc] initWithData:_data encoding:NSNonLossyASCIIStringEncoding];
        if (!string) string = [[NSString alloc] initWithData:_data encoding:NSNonLossyASCIIStringEncoding];        
        
        
        if (_format == WAX_HTTP_JSON) {
            json_parseString(L, [string UTF8String]);            
        }
        else if (_format == WAX_HTTP_XML){
#ifdef WAX_XML_INCLUDED
            wax_xml_parseString(L, [string UTF8String]);
#else
			luaL_error(L, "Trying to parse xml, but xml library not included.");
#endif
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
    if (_error) {
        wax_fromObjc(L, "@", &_error);
    }
    else {
        lua_pushnil(L);
    }

    
    
    if (hasCallback && wax_pcall(L, 3, 0)) {
        const char* error_string = lua_tostring(L, -1);
        luaL_error(L, "Problem calling Lua function '%s' from wax_http.\n%s", WAX_HTTP_CALLBACK_FUNCTION_NAME, error_string);
    }
    
    _finished = YES;
    
    END_STACK_MODIFY(L, 3)
}

@end
