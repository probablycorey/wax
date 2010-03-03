//
//  SimpleProtocolLoader.h
//  Rentals
//
//  Created by ProbablyInteractive on 8/2/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleProtocol.h"

// In order to dynamically associate a protocol... The protocol needs to have been used before.
// This seems to be a bug, but I'm not sure how to load the protocol via the runtime
@interface SimpleProtocolLoader : NSObject <SimpleProtocol> {

}

@end

@implementation SimpleProtocolLoader

- (id)requiredMethod {return nil;};
- (id)requiredMethodWithArg:(id)arg {return nil;};

@end
