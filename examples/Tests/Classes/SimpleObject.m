//
//  SimpleObject.m
//  Rentals
//
//  Created by ProbablyInteractive on 8/2/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "SimpleObject.h"


@implementation SimpleObject

- (void)dealloc {
    [_value release];
    [super dealloc];
}

- (NSString *)description {
    return _value;
}

- (id)initWithValue:(NSString *)value {
    self = [super init];    
    _value = [value retain];
    
    return self;
}

- (id)initWithWord:(NSString *)word {
    self = [super init];    
    _value = [word retain];
    
    return self;
}

- (NSString *)value {
    return _value;
}

- (NSString *)valueOverride {
    return _value;
}

+ (NSString *)helloMommy {
    return @"Hi Corey!";
}

+ (id)stored:(id)obj {
    static id stored;
    if (obj) {
        [stored release];
        stored = [obj retain];    
    }
    
    return stored;
}

@end
