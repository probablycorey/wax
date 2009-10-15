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

@implementation ___PROJECTNAMEASIDENTIFIER___AppDelegate

@synthesize window;

- (void)dealloc {
    [window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window makeKeyAndVisible];
    
    wax_start();
    
    // If you want to load wax with some extensions, replace the wax_start() line
    // above with
    // wax_startWithExtensions(luaopen_HTTPotluck, luaopen_json, nil);
    // 
    // Also import these files
    // #import "json.h"
    // #import "HTTPotluck.h"
    
}


@end
