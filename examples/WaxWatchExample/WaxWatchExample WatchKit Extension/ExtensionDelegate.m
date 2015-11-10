//
//  ExtensionDelegate.m
//  WaxWatchExample WatchKit Extension
//
//  Created by junzhan on 15/10/28.
//  Copyright © 2015年 test.jz.com. All rights reserved.
//

#import "ExtensionDelegate.h"
#import "wax.h"
@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    // Perform any final initialization of your application.
    wax_start(nil, nil);
    wax_runLuaString("print('hello wax')");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"watch" ofType:@"lua"];
    wax_runLuaFile(path.UTF8String);
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}

@end
