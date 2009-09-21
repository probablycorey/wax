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

@implementation HTTPotluck_connection

@synthesize format=_format;

- (void)dealloc {
    [_data release];
    [_response release];
    [super dealloc];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest luaState:(lua_State *)luaState {
    [super initWithRequest:urlRequest delegate:self];
    L = luaState;
    _data = [[NSMutableData alloc] init];
    _format = HTTPOTLUCK_TEXT;
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
    BEGIN_STACK_MODIFY(L)

    wax_instance_pushUserdata(L, self);
    lua_getfield(L, -1, HTTPOTLUCK_CALLBACK_FUNCTION_NAME);
            
    lua_pushnil(L); // Body        

    // Push the HTTPResponse    
    if (_response) {
        wax_fromObjc(L, "@", &_response);
    }
    else {
        lua_pushnil(L);
    }
    
    if (wax_pcall(L, 2, 0)) {
        const char* error_string = lua_tostring(L, -1);
        printf("Problem calling Lua function '%s' from HTTPPotluck.\n%s", HTTPOTLUCK_CALLBACK_FUNCTION_NAME, error_string);
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not connect to the Internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    [connection release];
    END_STACK_MODIFY(L, 0)
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    BEGIN_STACK_MODIFY(L)    
    wax_instance_pushUserdata(L, self);
    lua_getfield(L, -1, HTTPOTLUCK_CALLBACK_FUNCTION_NAME);
    
        // Body
    if (_format == HTTPOTLUCK_TEXT) {
        NSString *bodyString = [[[NSString alloc] initWithData:_data encoding:NSASCIIStringEncoding] autorelease];
        lua_pushstring(L, [bodyString UTF8String]);
    }
    else if (_format == HTTPOTLUCK_BINARY) {
        wax_instance_create(L, _data, NO); 
    }
    else {
        luaL_error(L, "HTTPotluck: Unknown HTTPotlock format '%d'", _format);
    }
        
    // Push the HTTPResponse
    wax_fromObjc(L, "@", &_response);
        
    if (wax_pcall(L, 2, 0)) {
        const char* error_string = lua_tostring(L, -1);
        printf("Problem calling Lua function '%s' from HTTPPotluck.\n%s", HTTPOTLUCK_CALLBACK_FUNCTION_NAME, error_string);
    }
    
    [connection release];
    END_STACK_MODIFY(L, 0);
}

@end
