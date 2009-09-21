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
};

#define HTTPOTLUCK_CALLBACK_FUNCTION_NAME "callback"

@interface HTTPotluck_connection : NSURLConnection {
    lua_State *L;
    NSMutableData *_data;
    NSHTTPURLResponse *_response;
    int _format;
}

@property (nonatomic, assign) int format;

- (id)initWithRequest:(NSURLRequest *)urlRequest luaState:(lua_State *)luaState;

@end

