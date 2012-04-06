//
//  wax_garbage_collection.h
//  WaxTests
//
//  Created by Corey Johnson on 2/23/10.
//  Copyright 2010 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface wax_gc : NSObject {

}

+ (void)start;
+ (void)stop;
+ (void)cleanupUnusedObject;

@end
