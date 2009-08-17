//
//  OinkTestsAppDelegate.m
//  OinkTests
//
//  Created by Corey Johnson on 8/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "OinkTestsAppDelegate.h"
#import "oink.h"

@implementation OinkTestsAppDelegate

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
