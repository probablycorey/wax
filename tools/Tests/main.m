//
//  main.m
//  Tests
//
//  Created by Corey Johnson on 3/3/10.
//  Copyright Probably Interactive 2010. All rights reserved.
//
// This where the magic happens!
// Wax doesn't use nibs to load the main view, everything is done within the
// WAX_LUA_INIT_SCRIPT file

#import <UIKit/UIKit.h>

#import "WaxTextField.h"

#import "wax.h"
#import "wax_http.h"
#import "wax_json.h"
#import "wax_xml.h"

#import "SimpleProtocolLoader.h" // Runtime can't dynamically load protocols... lame

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    wax_start(WAX_LUA_INIT_SCRIPT, luaopen_wax_http, luaopen_wax_json, luaopen_wax_xml, nil);
	
    int retVal = UIApplicationMain(argc, argv, nil, [NSString stringWithUTF8String:WAX_LUA_INIT_SCRIPT]);
    [pool release];
    return retVal;
}
