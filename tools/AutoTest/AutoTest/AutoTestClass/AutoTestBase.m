//
//  AutoTestBase.m
//  
//
//  Created by junzhan on 15-1-5.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "AutoTestBase.h"
#import "AutoTestUtil.h"
@implementation AutoTestBase

+ (void)autoTestStart{
    id instance = [[self alloc] init];
    
    [instance beforeAutoTestStart];
    
    [instance autoTestStart];
    
    [instance afterAutoTestStart];
}

- (void)beforeAutoTestStart{
    NSString *className = NSStringFromClass([self class]);
    [AutoTestUtil runLuaFileInBundle:className];
}

- (void)autoTestStart{
    
}

- (void)afterAutoTestStart{
    
}


- (id)testSuperMethodReturnId{
    return TEST_VALUE_STRING;
}

@end
