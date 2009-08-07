//
//  SimpleDelegateObject.m
//  Rentals
//
//  Created by ProbablyInteractive on 8/2/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "SimpleDelegateObject.h"

@implementation SimpleDelegateObject

@synthesize delegate;

- (id)callRequiredMethod {
    return [delegate requiredMethod];
}

- (id)callRequiredMethodWithArg:(id)arg {
    return [delegate requiredMethodWithArg:arg];    
}

- (id)callOptionalMethod {
    return [delegate optionalMethod];
}

- (id)callOptionalMethodWithArg:(id)arg {
    return [delegate optionalMethodWithArg:arg];    
}

@end
