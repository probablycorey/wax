//
//    HTTPotluck_connection.h
//    RentList
//
//    Created by Corey Johnson on 8/9/09.
//    Copyright 2009 ProbablyInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

enum {
    HTTPOTLUCK_TEXT,
    HTTPOTLUCK_BINARY, // Like an image or something
    HTTPOTLUCK_JSON
};

#define HTTPOTLUCK_CALLBACK_FUNCTION_NAME "callback"

@interface HTTPotluck_connection : NSURLConnection {
    lua_State *L;
    NSMutableData *_data;
    NSHTTPURLResponse *_response;
    id _body;

    int _format;
    bool _finished;
}

@property (nonatomic, assign) id body;
@property (nonatomic, assign) NSHTTPURLResponse *response;

@property (nonatomic, assign) int format;
@property (nonatomic, readonly) bool finished;

- (id)initWithRequest:(NSURLRequest *)urlRequest luaState:(lua_State *)luaState;
- (void)callLuaCallback:(NSURLConnection *)connection;

@end

