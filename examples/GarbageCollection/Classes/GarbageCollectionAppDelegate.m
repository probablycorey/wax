//
//  GarbageCollectionAppDelegate.m
//  GarbageCollection
//
//  Created by Corey Johnson on 8/26/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "GarbageCollectionAppDelegate.h"
#import "oink.h"

@implementation GarbageCollectionAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window makeKeyAndVisible];    
    oink_start();
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end