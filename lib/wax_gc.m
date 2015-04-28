//
//  wax_garbage_collection.m
//  WaxTests
//
//  Created by Corey Johnson on 2/23/10.
//  Copyright 2010 Probably Interactive. All rights reserved.
//

#import "wax_gc.h"

#import "lua.h"
#import "lauxlib.h"

#import "wax.h"
#import "wax_instance.h"
#import "wax_helpers.h"

static NSInteger WAX_GC_TIMEOUT = 5;//default 5 seconds

@implementation wax_gc

static NSTimer* timer = nil;

+ (void)start {
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:WAX_GC_TIMEOUT target:self selector:@selector(cleanupUnusedObject) userInfo:nil repeats:YES];
}

+ (void)stop {
    [timer invalidate];
    timer = nil;
}

//GC step：remove from strongUserTable、remove from weakUserdataTable、instance release
+ (void)cleanupUnusedObject {
//    NSLog(@"cleanupUnusedObject");
    lua_State *L = wax_currentLuaState();
    BEGIN_STACK_MODIFY(L)
    
    wax_instance_pushStrongUserdataTable(L);

    BOOL needLuaGC = NO;//Mark whether to launch a full garbage collection cycle
    
    lua_pushnil(L);  // first key
    while (lua_next(L, -2)) {
        wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, -1, WAX_INSTANCE_METATABLE_NAME);
        lua_pop(L, 1); // pops the value, keeps the key
            
        if (!instanceUserdata->isClass && !instanceUserdata->isSuper && [instanceUserdata->instance retainCount] <= 1) {
//            NSLog(@"instanceUserdata=%p retainCount=%d instance=%@  class=%@ p=%p ", instanceUserdata, [instanceUserdata->instance retainCount], instanceUserdata->instance, [instanceUserdata->instance class], instanceUserdata->instance);
            lua_pushvalue(L, -1);
            lua_pushnil(L);
            lua_rawset(L, -4); // Clear it!
            
            needLuaGC = YES;//
        }
    }
    
    if(needLuaGC){
        lua_gc(L, LUA_GCCOLLECT, 0);//To launch a full garbage collection cycle. Reference is removed in the strongUserTable, also need to remove references in the weakUserdataTable (or alloc for new objects have the same pointer will be crash), so the lua_gc to trigger the wax_instance __gc
    }
    END_STACK_MODIFY(L, 0);
}

+ (void)setWaxGCTimeout:(NSInteger)time{
    WAX_GC_TIMEOUT = time;
    [self stop];
    [self start];
}

@end
