//
//  SimpleProtocol.h
//  Rentals
//
//  Created by ProbablyInteractive on 8/2/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SimpleProtocol

- (id)requiredMethod;
- (id)requiredMethodWithArg:(id)arg;

@optional

- (id)optionalMethod;
- (id)optionalMethodWithArg:(id)arg;

@end