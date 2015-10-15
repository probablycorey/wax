//
//  AutoTestBlockTransfer.m
//  
//
//  Created by junzhan on 15-1-6.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "AutoTestBlockTransfer.h"
#import "AutoTestUtil.h"
@implementation AutoTestBlockTransfer

- (void)autoTestStart{
//lua里翻译这些block逻辑
    [self testReturnVoidWithFirstIntBlock:^(int aFirstInt, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId) {
        NSLog(@"ok");
    }];
}

- (void)testReturnVoidWithVoidBlock:(void(^)())block{
    block();
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}



//i^csiqfdB@@
- (void)testReturnVoidWithFirstIntBlock:(void(^)(int aFirstInt, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{

    block(TEST_VALUE_INT, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

//B^csiqfdB@@
- (void)testReturnBOOLWithFirstBOOLBlock:(BOOL(^)(BOOL aFirstBOOL,  BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{
    BOOL res = block(TEST_VALUE_BOOL, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%d F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert(res == TEST_VALUE_BOOL, @"%s返回值错误", __PRETTY_FUNCTION__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

- (void)testReturnIntWithFirstIntBlock:(int(^)(int aFirstInt, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{
    int res = block(TEST_VALUE_INT, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%d F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert(res == TEST_VALUE_INT, @"返回值错误");
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

- (void)testReturnIntegerWithFirstIntegerBlock:(NSInteger(^)(NSInteger aFirstInteger, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{
    NSInteger res = block(TEST_VALUE_INTEGER, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%ld F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert(res == TEST_VALUE_INTEGER, @"返回值错误");
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

- (void)testReturnCharPointerWithFirstCharPointerBlock:(char *(^)(char *aFirstCharPointer, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{
    char *res = block(TEST_VALUE_CHAR_POINTER, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%s F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert(strcmp(res, TEST_VALUE_CHAR_POINTER) == 0, @"%s返回值错误", __PRETTY_FUNCTION__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

- (void)testReturnVoidPointerWithFirstVoidPointerBlock:(void *(^)(void *aFirstVoidPointer, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{
    void *res = block(TEST_VALUE_VOID_POINTER, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%p F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert(res == TEST_VALUE_VOID_POINTER, @"%s返回值错误", __PRETTY_FUNCTION__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

- (void)testReturnIdWithFirstIdBlock:(id(^)(id aFirstId, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{
    UIViewController *vc = [[UIViewController alloc] init];
    id res = block(vc, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%@ F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert([res isKindOfClass:[UIViewController class]], @"%s返回值错误", __PRETTY_FUNCTION__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

#pragma mark float

- (void)testReturnFloatWithFirstFloatBlock:(float(^)(float aFirstFloat, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{
    float res = block(TEST_VALUE_FLOAT, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%f F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert([AutoTestUtil isDoubleEqual:res aDouble:TEST_VALUE_FLOAT], @"%s返回值错误", __PRETTY_FUNCTION__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

- (void)testReturnCGFloatWithFirstCGFloatBlock:(CGFloat(^)(CGFloat aFirstCGFloat, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{
    CGFloat res = block(TEST_VALUE_CGFLOAT, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%f F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert([AutoTestUtil isDoubleEqual:res aDouble:TEST_VALUE_CGFLOAT], @"%s返回值错误", __PRETTY_FUNCTION__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

- (void)testReturnDoubleWithFirstDoubleBlock:(double(^)(double aFirstDouble, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block{
    
    double res = block(TEST_VALUE_DOUBLE, TEST_VALUE_BOOL, TEST_VALUE_INT, TEST_VALUE_INTEGER, TEST_VALUE_FLOAT,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%f F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert([AutoTestUtil isDoubleEqual:res aDouble:TEST_VALUE_DOUBLE], @"%s返回值错误", __PRETTY_FUNCTION__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}
@end
