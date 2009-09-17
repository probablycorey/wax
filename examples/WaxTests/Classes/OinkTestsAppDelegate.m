//
//  OinkTestsAppDelegate.m
//  OinkTests
//
//  Created by Corey Johnson on 8/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "OinkTestsAppDelegate.h"
#import "SimpleProtocolLoader.h" // Runtime can't dynamically load protocols... lame
#import "wax.h"

@implementation OinkTestsAppDelegate

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
