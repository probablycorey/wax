//
//  main.m
//  IBExample
//
//  Created by Corey Johnson on 3/9/10.
//  Copyright Probably Interactive 2010. All rights reserved.
//
// This where the magic happens!
// Wax doesn't use nibs to load the main view, everything is done within the
// AppDelegate.lua file

#import <UIKit/UIKit.h>

#import "ProtocolLoader.h"
#import "WaxTextField.h"

#import "wax.h"
#import "wax_http.h"
#import "wax_json.h"
#import "wax_xml.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    wax_startWithExtensions(luaopen_wax_http, luaopen_wax_json, luaopen_wax_xml, nil);
    
    int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
    [pool release];
    return retVal;
}
