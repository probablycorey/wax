//
//  AutoTest64MethodHookVC.m
//  
//
//  Created by junzhan on 15-1-4.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "AutoTestHookMethod.h"
#import "AutoTestUtil.h"
@interface AutoTestHookMethod ()

@end

@implementation AutoTestHookMethod
//此方法会被自动调用
- (void)autoTestStart{
    [self testHookMethod];
    [self testAddMethod];
    [self testMutiThreadSafe];
}

#pragma mark hook
- (void)testHookMethod{
    [self testHookReturnVoid];
    NSAssert([self testHookReturnId] == self, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([self testHookaId:self] == self, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([self testHookaInt:TEST_VALUE_INT] == TEST_VALUE_INT, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([self testHookaLongLong:TEST_VALUE_LONG_LONG] == TEST_VALUE_LONG_LONG, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    
    
    NSAssert([self testHookaBOOL:TEST_VALUE_BOOL] == TEST_VALUE_BOOL, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([self testHookaFloat:TEST_VALUE_FLOAT] == TEST_VALUE_FLOAT, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([self testHookaDouble:TEST_VALUE_DOUBLE] == TEST_VALUE_DOUBLE, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    
    
    NSAssert([self testHookaInteger:TEST_VALUE_INTEGER bId:[UIViewController new] cId:[UIView new] dId:[UILabel new]] == TEST_VALUE_INTEGER, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    
    NSAssert([self testHookaChar:TEST_VALUE_CHAR aInteger:TEST_VALUE_INTEGER aBOOL:YES aDouble:TEST_VALUE_DOUBLE aString:@"hij" aId:self] == TEST_VALUE_CHAR, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
}

//char aChar, int aInt, NSInteger aInteger, BOOL aBOOL, bool aBool, char *aCharPointer, short aShort,  NSUInteger aUInteger, long long aLongLong, unsigned long long aULongLong, float aFloat, CGFloat aCGFloat, double aDouble, void *aVoidPointer, NSString *aString, id aId)

- (void)testHookReturnVoid{
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

- (id)testHookReturnId{
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    return self;
}

- (id)testHookaId:(id)aId{
    NSAssert(aId == self, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    return aId;
}

- (int)testHookaInt:(int)aInt{
    NSAssert(aInt == TEST_VALUE_INT, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    return aInt;
}

- (long long)testHookaLongLong:(long long)aLongLong{
    NSAssert(aLongLong == TEST_VALUE_LONG_LONG, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    return aLongLong;
}

- (BOOL)testHookaBOOL:(BOOL)aBOOL{
    NSLog(@"TEST_VALUE_BOOL=%d", TEST_VALUE_BOOL);
    NSAssert(aBOOL == TEST_VALUE_BOOL, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    return aBOOL;
}

- (float)testHookaFloat:(float)aFloat{
    NSAssert([AutoTestUtil isDoubleEqual:aFloat aDouble:TEST_VALUE_FLOAT], @"浮点数不相等");
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    return aFloat;
}

- (double)testHookaDouble:(double)aDouble{
    NSAssert([AutoTestUtil isDoubleEqual:aDouble aDouble:TEST_VALUE_DOUBLE], @"浮点数不相等");
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    return aDouble;
}

- (NSInteger)testHookaInteger:(NSInteger)aInteger bId:(id)bId cId:(id)cId dId:(id)dId{
    NSAssert(aInteger == TEST_VALUE_INTEGER, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([bId isKindOfClass:[UIViewController class]], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([cId isKindOfClass:[UIView class]], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([dId isKindOfClass:[UILabel class]], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    return aInteger;
}

- (char)testHookaChar:(char) aChar aInteger:(NSInteger)aInteger aBOOL:(BOOL)aBOOL aDouble:(double) aDouble aString:(NSString *)aString aId:(id) aId{
    
    NSAssert(aChar=='a', @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert(aInteger==TEST_VALUE_INTEGER, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert(aBOOL==YES, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([AutoTestUtil isDoubleEqual:aDouble aDouble:12345.6789], @"浮点数不相等");
    
    NSAssert([aString isEqualToString:@"hij"], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert(aId == self, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    return aChar;
}


#pragma mark 测试新增方法

- (void)testAddMethod{
    [self testAddMethodWithVoid];
    NSAssert([self testAddMethodWithaId:self] == self, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    
    NSAssert([[self testAddMethodWithaId:@"abc" bId:[NSNumber numberWithInteger:TEST_VALUE_INTEGER] cId:[UIViewController new] dId:@{@"key":@"value"} eId:self] isEqualToString:@"abc"], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
}

//- (void)testAddMethodWithVoid{
//    
//}
//
//- (id)testAddMethodWithaId:(NSString *)aId{
//    return aId;
//}
//
//- (id)testAddMethodWithaId:(NSString *)aId bId:(NSNumber *)bId cId:(UIViewController *)cId dId:(NSDictionary *)dId eId:(id)eid{
//    return aId;
//}

#pragma mark 测试hook线程安全

- (void)testMutiThreadSafe{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (int i = 0; i < 1000; ++i) {
            NSString *name = [NSString stringWithFormat:@"oc.queue.%d", i%10];
            dispatch_queue_t queue = dispatch_queue_create([name UTF8String], DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue, ^{
                [NSThread sleepForTimeInterval:rand()%10/1000.0];
                if(i&1){
                    [self testHookMethod];
                }else{
                    [self testAddMethod];
                }
                
            });
        }
    });
}
@end
