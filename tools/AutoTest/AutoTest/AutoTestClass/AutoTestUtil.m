//
//  AutoTestUtil.m
//  
//
//  Created by junzhan on 15-4-16.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "AutoTestUtil.h"
#import "wax.h"
#define EPS 1e-4
@implementation AutoTestUtil

+ (void)runLuaFileInBundle:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"lua"];
    NSString *script = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSInteger i = wax_runLuaString([script UTF8String]);
    NSAssert(i == 0, @"error=%s", lua_tostring(wax_currentLuaState(), -1));
}

+ (BOOL)isDoubleEqual:(double)firstDouble aDouble:(double)aDouble{
    return fabs(firstDouble - aDouble) < EPS;
}

@end
