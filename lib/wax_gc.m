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

static NSInteger WAX_GC_TIMEOUT = 1;//default 1 seconds

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

    if([wax_globalLock() tryLock]){//if blocked by other thread then ignore this cycle , avoid block main thread
//        NSLog(@"tryLock success");
        
        lua_State *L = wax_currentLuaState();
        BEGIN_STACK_MODIFY(L)
        
        wax_instance_pushStrongUserdataTable(L);
        
        BOOL needLuaGC = NO;//check need gc
        
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
            lua_gc(L, LUA_GCCOLLECT, 0);//force invoke __gc in wax_instance
        }
        END_STACK_MODIFY(L, 0);
        
        [wax_globalLock() unlock];//remember unlock
    }else{
//        NSLog(@"tryLock failed");
    }
}

+ (void)setWaxGCTimeout:(NSInteger)time{
    if(time <= 0){//maybe for same case, you need to stop
        [self stop];
    }else{
        WAX_GC_TIMEOUT = time;
        [self stop];
        [self start];
    }
}


//in dealloc method, manual GC wax instance.
int waxGCInstance(lua_State *L){
    BEGIN_STACK_MODIFY(L)
    
    wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
    
    //remove from strongUserTable
    wax_instance_pushStrongUserdataTable(L);
    wax_printTable(L, -1);
    lua_pushlightuserdata(L, instanceUserdata->instance);
    lua_pushnil(L);
    lua_rawset(L, -3);
    lua_pop(L, 1);
    
    //remove from weakUserdataTable
    wax_instance_pushUserdataTable(L);
    wax_printTable(L, -1);
    lua_pushlightuserdata(L, instanceUserdata->instance);
    lua_pushnil(L);
    lua_rawset(L, -3);
    lua_pop(L, 1);
    
    //remove it's metatable, or it will call __gc and release crash.
    lua_pushnil(L);
    lua_setmetatable(L, -2);
    
    END_STACK_MODIFY(L, 0);
    return  0;
}

@end
