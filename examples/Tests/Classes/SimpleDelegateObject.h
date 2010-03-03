//
//  SimpleDelegateObject.h
//  Rentals
//
//  Created by ProbablyInteractive on 8/2/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleProtocol.h"

@interface SimpleDelegateObject : NSObject {
    id<SimpleProtocol> delegate;
}

@property(nonatomic,retain) id<SimpleProtocol> delegate;

- (id)callRequiredMethod;
- (id)callRequiredMethodWithArg:(id)arg;
- (id)callOptionalMethod;
- (id)callOptionalMethodWithArg:(id)arg;

@end
