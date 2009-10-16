//
//    HTTPotluck_connection.m
//    RentList
//
//    Created by Corey Johnson on 8/9/09.
//    Copyright 2009 ProbablyInteractive. All rights reserved.
//

#import "HTTPotluck_connection.h"
#import "lauxlib.h"
#import "wax_instance.h"
#import "wax_helpers.h"
#import "json.h"

@implementation HTTPotluck_connection

@synthesize response=_response;
@synthesize format=_format;
@synthesize finished=_finished;

- (void)dealloc {
    [_data release];
    [_response release];
    [super dealloc];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest luaState:(lua_State *)luaState {
    [super initWithRequest:urlRequest delegate:self];
    L = luaState;
    _data = [[NSMutableData alloc] init];
    _format = HTTPOTLUCK_UNKNOWN;
	_error = NO;
    return self;
}

- (void)cancel {
    [super cancel];
    [self release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (response != _response) [_response release];
    _response = [response retain];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	_error = YES;
	[_data release];
    _data = [[error localizedDescription] retain];
    [self callLuaCallback:connection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self callLuaCallback:connection];
}

- (void)callLuaCallback:(NSURLConnection *)connection {    
    BEGIN_STACK_MODIFY(L)

    wax_instance_pushUserdata(L, self);
    lua_getfield(L, -1, HTTPOTLUCK_CALLBACK_FUNCTION_NAME);
    
    bool hasCallback = YES;
    if (lua_isnil(L, -1)) { 
        hasCallback = NO;
        lua_pop(L, 1);
    }
    
	// Try and guess the format type
	if (_format == HTTPOTLUCK_UNKNOWN) {
		NSString *contentType = [[_response allHeaderFields] objectForKey:@"Content-Type"];
		if ([contentType hasPrefix:@"application/json"] ||
			[contentType hasPrefix:@"text/json"] ||
			[contentType hasPrefix:@"application/javascript"] ||
			[contentType hasPrefix:@"text/javascript"]) {
			_format = HTTPOTLUCK_JSON;
		}
		else if ([contentType hasPrefix:@"image/"] ||
				 [contentType hasPrefix:@"audio/"]) {
			_format = HTTPOTLUCK_BINARY;
		}
		else {
			_format = HTTPOTLUCK_TEXT;
		}
	}
	
	if (_error) {
		lua_pushnil(L);
	}
	else if (_format == HTTPOTLUCK_TEXT || _format == HTTPOTLUCK_JSON) {
		NSString *string = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
		
		if (_format == HTTPOTLUCK_TEXT) {
			wax_fromObjc(L, "@", &string);
		}
		else {
			json_parseString(L, [string UTF8String]);
		}
		
		[string release];
	}
	else if (_format == HTTPOTLUCK_BINARY) {		
		wax_fromObjc(L, "@", &_data);
	}
	else {
		luaL_error(L, "HTTPotluck: Unknown HTTPotlock format '%d'", _format);
	}
	
    wax_fromObjc(L, "@", &_response);
	wax_fromObjc(L, "@", &_data); // Send the raw data too (since oddly, the response doesn't contain it)
        
    if (hasCallback && wax_pcall(L, 3, 0)) {
        const char* error_string = lua_tostring(L, -1);
        printf("Problem calling Lua function '%s' from HTTPPotluck.\n%s", HTTPOTLUCK_CALLBACK_FUNCTION_NAME, error_string);
    }
    
    [connection release];
    
    _finished = YES;
    
    END_STACK_MODIFY(L, hasCallback ? 0 : 3)
}

@end
