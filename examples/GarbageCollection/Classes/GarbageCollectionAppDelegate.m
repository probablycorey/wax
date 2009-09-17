//
//  GarbageCollectionAppDelegate.m
//  GarbageCollection
//
//  Created by Corey Johnson on 8/26/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "GarbageCollectionAppDelegate.h"
#import "wax.h"

@implementation GarbageCollectionAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window makeKeyAndVisible];    
    wax_start();
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end