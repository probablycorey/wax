//
//  StatesAppDelegate.m
//  States
//
//  Created by Corey Johnson on 9/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.

#import "StatesAppDelegate.h"

#import "ProtocolLoader.h"
#import "WaxTextField.h"

#import "wax.h"

@implementation StatesAppDelegate

@synthesize window;

- (void)dealloc {
    [window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window makeKeyAndVisible];
    
    wax_start();
    
    // If you want to load wax with some extensions use this function
    //wax_startWithExtensions(luaopen_HTTPotluck, luaopen_json, nil);
}


@end
