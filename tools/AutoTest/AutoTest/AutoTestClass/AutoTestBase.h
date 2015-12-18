//
//  AutoTestBase.h
//  
//
//  Created by junzhan on 15-1-5.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AutoTestBase : NSObject

+ (void)autoTestStart;

/**
 *  it will run script by default. you can override it
 */
- (void)beforeAutoTestStart;

/**
 *  intry for lua test script
 */
- (void)autoTestStart;

- (void)afterAutoTestStart;


- (id)testSuperMethodReturnId;
@end
