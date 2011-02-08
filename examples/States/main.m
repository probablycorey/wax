//
//  main.m
//  States
//
//  Copyright 2010 Corey Johnson. All rights reserved.
//
//  This where the magic happens!
//  Wax doesn't use nibs to load the main view, everything is done within the
//  AppDelegate.lua file

#import <UIKit/UIKit.h>

#import "wax/wax.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    wax_start("AppDelegate", nil);
    
    int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
    [pool release];
    return retVal;
}