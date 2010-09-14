//
//  main.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//
// This where the magic happens!
// Wax doesn't use nibs to load the main view, everything is done within the
// AppDelegate.lua file

#import <UIKit/UIKit.h>

#import "ProtocolLoader.h"

#import "wax.h"
#import "wax_http.h"
#import "wax_json.h"
#import "wax_xml.h"
#import "wax_ziploader.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    wax_startWithExtensions(luaopen_wax_http, luaopen_wax_json, luaopen_wax_xml, luaopen_wax_ziploader, nil);
    
    int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
    [pool release];
    return retVal;
}
