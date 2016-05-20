//
//  AutoTest64MethodHookVC.m
//  TBHotpatchSDKTest
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
    //
    [[self class] testHookClassMethod];
    [self testUnderlinePrefixMethod];
    [self testStructMethod];
    [self testDollorMethod];

    //    [self testTimeConsuming];
}

#pragma mark hook

- (void)testTimeConsuming{
    int n = 1000;
    NSTimeInterval start = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
    
    for(int i = 0; i < n; ++i){
        [self testHookMethod];
    }
    NSTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"start=%f, end=%f", start, end);
    NSLog(@"total cost=%.0f\n\n", (end-start)*1000.0);
}

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
    
    NSAssert([self testSuperMethodReturnId] == self, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
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
                [NSThread sleepForTimeInterval:rand()%100/1000.0];
                if(i&1){
                    [self testHookMethod];
                }else{
                    [self testAddMethod];
                }
                
            });
        }
    });
}

#pragma mark test hook Class method

+ (void)testHookClassMethod{
    [self testHookClassaId:self];
    NSAssert([self testHookClassReturnIdWithaId:self] == self, @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
}

+ (void)testHookClassaId:(id)aId{
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    NSLog(@"aId=%@", aId);
}

+ (id)testHookClassReturnIdWithaId:(id)aId{
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
    NSLog(@"aId=%@", aId);
    return aId;
}

#pragma mark test underline prefix method

- (void)testUnderlinePrefixMethod{
    [self _prefixMethod:@"abc"];
    [self _prefixMethodA:@"abc" B:@"efg"];
    [self _];
    [self _prefixA:@"abc" _b:@"efg"];
    [self __aa_bb_:@"abc" _cc__dd_:@"efg" ___ee___f___:@"hij"];
    [[self class] ___aa_bb_:@"abc" _cc__dd_:@"efg" ___ee___f___:@"hij"];
}

- (id)_{
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
    return self;
}

- (void)_prefixMethod:(NSString *)str{
    NSAssert([str isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
}

- (id)_prefixMethodA:(NSString *)str B:(NSString *)b{
    NSAssert([str isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([b isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
    return str;
}

- (void)_prefixA:(NSString *)a _b:(NSString *)b{
    NSAssert([a isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([b isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
}

- (id)__aa_bb_:(NSString *)v1 _cc__dd_ :(NSString *)v2 ___ee___f___:(NSString *)v3{
    NSAssert([v1 isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([v2 isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([v3 isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
    return v1;
}

+ (id)___aa_bb_:(NSString *)v1 _cc__dd_:(NSString *)v2 ___ee___f___:(NSString *)v3{
    NSAssert([v1 isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([v2 isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSAssert([v3 isEqualToString:TEST_VALUE_STRING], @"FUN:%s LINE:%d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
    return v1;
}

#pragma mark test hook struct method

- (void)testStructMethod{
    id x = [self initWithFrame:TEST_VALUE_CGRECT];
    CGRect rect = [self testReturnCGRectWithCGRect:TEST_VALUE_CGRECT];
    
    NSAssert(CGRectEqualToRect(rect, CGRectMake(TEST_VALUE_CGRECT.origin.x+10*2, TEST_VALUE_CGRECT.origin.y+20*2, TEST_VALUE_CGRECT.size.width+30*2, TEST_VALUE_CGRECT.size.height+40*2)), @"testReturnCGRectWithCGRect fail");
    
    CGRect rect2 =  [self testReturnCGRectWithaId:self aCGRect:TEST_VALUE_CGRECT];
    NSAssert(CGRectEqualToRect(rect2, CGRectMake(TEST_VALUE_CGRECT.origin.x+10*2, TEST_VALUE_CGRECT.origin.y+20*2, TEST_VALUE_CGRECT.size.width+30*2, TEST_VALUE_CGRECT.size.height+40*2))             , @"testReturnCGRectWithaId fail");
    
    CGPoint point = [self testReturnCGPointWithCGPoint:TEST_VALUE_CGPOINT];
    NSAssert(CGPointEqualToPoint(point, CGPointMake(TEST_VALUE_CGPOINT.x+10*2, TEST_VALUE_CGPOINT.y+20*2)), @"testReturnCGPointWithCGPoint fail");
    CGFloat aCGFloat = [[self class] testReturnCGFloatWithaPoint:TEST_VALUE_CGPOINT bPoint:TEST_VALUE_CGPOINT];
    NSAssert([AutoTestUtil isDoubleEqual:aCGFloat aDouble:(TEST_VALUE_CGPOINT.x+10+TEST_VALUE_CGPOINT.y+20)*2], @"testReturnCGFloatWithaPoint fail");
    
    //    CGSize size = [self testReturnCGSizeWithCGSize:TEST_VALUE_CGSize];
    //    NSAssert(CGSizeEqualToSize(size, CGSizeMake(TEST_VALUE_CGSize.width+10*2, TEST_VALUE_CGSize.height+20*2)), @"testReturnCGSizeWithCGSize fail");
    
    NSRange range = [self testReturnNSRangeWithNSRange:TEST_VALUE_NSRANGE];
    NSAssert(range.location == TEST_VALUE_NSRANGE.location+10*2 && range.length == TEST_VALUE_NSRANGE.length+20*2, @"testReturnNSRangeWithNSRange fail");
    range = [self testReturnNSRangeWithaId:self aNSRange:TEST_VALUE_NSRANGE];
    NSAssert(range.location == TEST_VALUE_NSRANGE.location+10*2 && range.length == TEST_VALUE_NSRANGE.length+20*2, @"testReturnNSRangeWithaId fail");
}


- (id)initWithFrame:(CGRect)aCGRect{
    NSLog(@"aCGRect=%@", NSStringFromCGRect(aCGRect));
    self = [super init];
    return  self;
}

- (CGRect)testReturnCGRectWithCGRect:(CGRect)aCGRect{
    return CGRectMake(aCGRect.origin.x+10, aCGRect.origin.y+20, aCGRect.size.width+30, aCGRect.size.height+40);
}

- (CGRect)testReturnCGRectWithaId:(id)aId aCGRect:(CGRect)aCGRect{
    return CGRectMake(aCGRect.origin.x+10, aCGRect.origin.y+20, aCGRect.size.width+30, aCGRect.size.height+40);
}

- (CGSize)testReturnCGSizeWithCGSize:(CGSize)aCGSize{
    return CGSizeMake(aCGSize.width+10, aCGSize.height+20);
}

- (CGPoint)testReturnCGPointWithCGPoint:(CGPoint)aCGPoint{
    return CGPointMake(aCGPoint.x+10, aCGPoint.y+20);
}
//a distance case
+ (CGFloat)testReturnCGFloatWithaPoint:(CGPoint)aPoint bPoint:(CGPoint)bPoint{
    return aPoint.x+aPoint.y+bPoint.x+bPoint.y;
}

- (NSRange)testReturnNSRangeWithNSRange:(NSRange)aNSRange{
    return NSMakeRange(aNSRange.location+10, aNSRange.length+20);
}

- (NSRange)testReturnNSRangeWithaId:(id)aId aNSRange:(NSRange)aNSRange{
    return NSMakeRange(aNSRange.location+10, aNSRange.length+20);
}


#pragma mark $$ method
- (void)testDollorMethod{
    NSAssert([[self $testDolorMethod] isEqualToString:TEST_VALUE_STRING], @"$testDolorMethod failed");
    NSAssert([[[self class] $testDolorClassMethod] isEqualToString:TEST_VALUE_STRING], @"$testDolorClassMethod failed");
    ;
    NSAssert([[self _$test$Dolor_Method:TEST_VALUE_STRING _b$:TEST_VALUE_STRING] isEqualToString:[TEST_VALUE_STRING stringByAppendingString:TEST_VALUE_STRING]], @"$testDolorMethod failed");
}

- (NSString *)$testDolorMethod{
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
    return nil;
}

+ (NSString *)$testDolorClassMethod{
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
    return nil;
}

- (NSString *)_$test$Dolor_Method:(NSString *)v1 _b$:(NSString *)v2{
    NSLog(@"F:%s L:%d", __PRETTY_FUNCTION__, __LINE__);
    return v1;
}

@end
