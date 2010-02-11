//
//  ___PROJECTNAMEASIDENTIFIER___AppDelegate.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.

#import "___PROJECTNAMEASIDENTIFIER___AppDelegate.h"

#import "ProtocolLoader.h"
#import "WaxTextField.h"

#import "wax.h"
#import "wax_http.h"
#import "wax_json.h"

@implementation ___PROJECTNAMEASIDENTIFIER___AppDelegate

@synthesize window;

- (void)dealloc {
    [window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window makeKeyAndVisible];
    
    wax_startWithExtensions(luaopen_wax_http, luaopen_wax_json, nil);

    // If you want to load wax with no extensions, replace the wax_startWithExtensions line
    // above with    
    // wax_start();    
}


@end
