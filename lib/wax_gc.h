//
//  wax_garbage_collection.h
//  WaxTests
//
//  Created by Corey Johnson on 2/23/10.
//  Copyright 2010 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

@interface wax_gc : NSObject {

}

+ (void)start;
+ (void)stop;
+ (void)cleanupUnusedObject;

//set gc time interval
+ (void)setWaxGCTimeout:(NSInteger)time;
@end

int waxGCInstance(lua_State *L);
