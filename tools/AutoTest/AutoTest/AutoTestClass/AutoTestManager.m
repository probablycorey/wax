//
//  AutoTestManager.m
//  
//
//  Created by junzhan on 15-1-5.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "AutoTestManager.h"
#import "AutoTestUtil.h"
@implementation AutoTestManager

+ (void)autoTestStart{
    [AutoTestUtil runLuaFileInBundle:@"AutoTestConfig"];
    
    NSArray *autoTestClassArray = @[@"AutoTestHookMethod", @"AutoTestBlockTransfer", @"AutoTestBlockCall", @"AutoTestRuntime", @"AutoTestGCD", @"AutoTestUIKitFunction"];
    for (NSString *className in autoTestClassArray){
        [AutoTestUtil runLuaFileInBundle:className];
        
        id class = NSClassFromString(className);
        [class autoTestStart];
    }
}

@end
