//
//  TwitterAppAppDelegate.m
//  TwitterApp
//
//  Created by Corey Johnson on 10/15/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.

#import "TwitterAppAppDelegate.h"

#import "ProtocolLoader.h"
#import "WaxTextField.h"

#import "wax.h"
#import "json.h"
#import "HTTPotluck.h"

@implementation TwitterAppAppDelegate

@synthesize window;

- (void)dealloc {
    [window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window makeKeyAndVisible];
    
    wax_startWithExtensions(luaopen_HTTPotluck, luaopen_json, nil);
}


@end
