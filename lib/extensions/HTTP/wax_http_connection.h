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
#define WAX_HTTP_PROGRESS_CALLBACK_FUNCTION_NAME "progressCallback"
#define WAX_HTTP_AUTH_CALLBACK_FUNCTION_NAME "authCallback"
#define WAX_HTTP_REDIRECT_CALLBACK_FUNCTION_NAME "redirectCallback"

@interface wax_http_connection : NSURLConnection {
    lua_State *L;
    NSMutableData *_data;
    NSHTTPURLResponse *_response;
    NSURLRequest *_request;
    NSTimer *_timeoutTimer;
    NSError *_error;
    
    NSTimeInterval _timeout;
    int _format;
    bool _finished;
    bool _canceled;
}

@property (nonatomic, assign) NSHTTPURLResponse *response;

@property (nonatomic, assign) int format;
@property (nonatomic, readonly, getter=isFinished) bool finished;

- (id)initWithRequest:(NSURLRequest *)urlRequest timeout:(NSTimeInterval)timeout luaState:(lua_State *)luaState;
- (void)callRedirectCallback:(NSURLResponse *)redirectResponse;
- (BOOL)callLuaAuthCallback:(NSURLAuthenticationChallenge *)challenge;
- (void)callLuaProgressCallback;
- (void)callLuaCallback;

// HSHTTPURLResponse Delegate Methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end

