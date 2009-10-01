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

@synthesize body=_body;
@synthesize response=_response;
@synthesize format=_format;
@synthesize finished=_finished;

- (void)dealloc {
    [_data release];
    [_response release];
    [_body release];
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
    _body = [[error localizedDescription] retain];
    [self callLuaCallback:connection];
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not connect to the Internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
//    [alertView release];    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Body
    if (_format == HTTPOTLUCK_TEXT || _format == HTTPOTLUCK_JSON) {
        _body = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    }
    else if (_format == HTTPOTLUCK_BINARY) {
        _body = [_data retain];
    }
    else {
        luaL_error(L, "HTTPotluck: Unknown HTTPotlock format '%d'", _format);
    }
            
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

    if (_format == HTTPOTLUCK_JSON) {
        json_parseString(L, [_body UTF8String]);
    }
    else {
        wax_fromObjc(L, "@", &_body);
    }
    
    wax_fromObjc(L, "@", &_response);
        
    if (hasCallback && wax_pcall(L, 2, 0)) {
        const char* error_string = lua_tostring(L, -1);
        printf("Problem calling Lua function '%s' from HTTPPotluck.\n%s", HTTPOTLUCK_CALLBACK_FUNCTION_NAME, error_string);
    }
    
    [connection release];
    
    _finished = YES;
    
    END_STACK_MODIFY(L, hasCallback ? 0 : 2)
}

@end
