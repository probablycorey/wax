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

- (id)initWithValue:(NSString *)value {
    self = [super init];    
    _value = [value retain];
    
    return self;
}

- (NSString *)value {
    return _value;
}

- (NSString *)valueOverride {
    return _value;
}

@end
