//
//  PureViewController.m
//  GarbageCollection
//
//  Created by Corey Johnson on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PureViewController.h"

@implementation PureViewController

- (void)dealloc {
    printf("%p ALL GONE\n", self);
    [super dealloc];
}

- (void)release {
    int retainCount = [self retainCount];
    uint pointer = (uint)self;
    [super release];    
    if (retainCount > 1) {
        printf("(%p) -1 %d\n", pointer, [self retainCount]);
    }
    else {
        printf("(%p) -1 0\n", pointer);
    }
}

- (id)retain {
    [super retain];
    printf("(%p) +1 %d\n", self, [self retainCount]);
    
    return self;
}


@end
