//
//  AutoTestGCD.m
//  
//
//  Created by junzhan on 15-4-16.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "AutoTestGCD.h"
#import "wax.h"
#include "lua.h"
#import "tolua++.h"
#import "AutoTestUtil.h"
@implementation AutoTestGCD

- (void)beforeAutoTestStart{
    TOLUA_API int  tolua_dispatch_open (lua_State* tolua_S);
    tolua_dispatch_open (wax_currentLuaState());
    
    [AutoTestUtil runLuaFileInBundle:NSStringFromClass([self class])];
}

//will be hooked
- (void)autoTestStart{
    
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    NSLog(@"main_queue=%s", dispatch_queue_get_label(main_queue));
    
    dispatch_queue_t global_queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"global_queue=%s", dispatch_queue_get_label(global_queue));
    
    dispatch_queue_t  create_queue = dispatch_queue_create("com.taobao.test", DISPATCH_QUEUE_SERIAL);
    NSLog(@"create_queue=%s", dispatch_queue_get_label(create_queue));
    
    dispatch_queue_t  current_queue = dispatch_get_current_queue();
    NSLog(@"current_queue=%s", dispatch_queue_get_label(current_queue));
    
    //    dispatch_main();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"dispatch_async");
    });
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"dispatch_sync");
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_after");
    });
    
    dispatch_apply(5, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
        NSLog(@"dispatch_apply count=%zu", i);
    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_queue_create("com.taobao.test", DISPATCH_QUEUE_SERIAL), ^{
        NSLog(@"dispatch_semaphore_t dispatch_semaphore_signal");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 10);
    NSLog(@"DISPATCH_TIME_NOW=%lld time=%lld", DISPATCH_TIME_NOW, time);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gw.alicdn.com/tps/i2/TB1M4BWHpXXXXbYXVXXdIns_XXX-1125-352.jpg_q50.jpg"]];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"data.length=%ld", data.length);
        });
    });
}


@end
