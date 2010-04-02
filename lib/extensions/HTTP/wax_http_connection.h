//
//    wax_http_connection.h
//    RentList
//
//    Created by Corey Johnson on 8/9/09.
//    Copyright 2009 ProbablyInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lua.h"

enum {
    WAX_HTTP_UNKNOWN,
    WAX_HTTP_TEXT,
    WAX_HTTP_BINARY, // Like an image or something
    WAX_HTTP_JSON,
    WAX_HTTP_XML
};

#define WAX_HTTP_CALLBACK_FUNCTION_NAME "callback"
#define WAX_HTTP_AUTH_CALLBACK_FUNCTION_NAME "authCallback"

@interface wax_http_connection : NSURLConnection {
    lua_State *L;
    NSMutableData *_data;
    NSHTTPURLResponse *_response;
    NSURLRequest *_request;
    
    int _format;
    bool _finished;
    bool _error;
    bool _canceled;
    double _cachePeriod;
}

@property (nonatomic, assign) NSHTTPURLResponse *response;

@property (nonatomic, assign) int format;
@property (nonatomic, readonly) bool finished;

- (id)initWithRequest:(NSURLRequest *)urlRequest cachePeriod:(double)cachePeriod luaState:(lua_State *)luaState;
- (BOOL)callLuaAuthCallback:(NSURLAuthenticationChallenge *)challenge;
- (void)callLuaCallback;

- (NSString *)cacheFilePath;
- (BOOL)cacheFound;
- (void)cacheData;
- (NSString *)md5HexDigest:(NSString *)input;

@end

