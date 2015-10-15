//
//  AutoTest64MethodHookVC.h
//  
//
//  Created by junzhan on 15-1-4.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "AutoTestBase.h"

@interface AutoTestHookMethod : AutoTestBase

//这些方法只申明实际由lua生成
- (void)testAddMethodWithVoid;
- (id)testAddMethodWithaId:(NSString *)aId;
- (id)testAddMethodWithaId:(NSString *)aId bId:(NSNumber *)bId cId:(UIViewController *)cId dId:(NSDictionary *)dId eId:(id)eid;
@end
