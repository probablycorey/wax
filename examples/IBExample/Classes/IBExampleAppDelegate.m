//
//  IBExampleAppDelegate.m
//  IBExample
//
//  Created by Corey on 1/3/11.
//  Copyright 2011 me. All rights reserved.
//

#import "IBExampleAppDelegate.h"
#import "wax/wax.h"

@implementation IBExampleAppDelegate

@synthesize window;

- (void)dealloc {
    [window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [self.window makeKeyAndVisible];
	wax_start("init.lua", nil);
    return YES;
}

@end
