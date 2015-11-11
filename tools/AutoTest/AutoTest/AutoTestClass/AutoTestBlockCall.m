//
//  BlockCallVC.m
//  
//
//  Created by junzhan on 14-8-25.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//

#import "AutoTestBlockCall.h"
#import "AutoTestUtil.h"
@interface AutoTestBlockCall ()
@property (strong, nonatomic) NSString *(^privateBlock)(NSString *str);
@end
typedef void (^YYZJSBResponse)(NSString * code, NSDictionary * responseData);
// 定义服务处理器类型(入参, 回写数据)
typedef void (^YYZJSBHandler)(id data, YYZJSBResponse yyzJSBResponseCallback);

// 定义新的服务处理器类型 - [4.0.0]
typedef void (^WVJSBHandler)(id data, YYZJSBResponse yyzJSBResponseCallback, UIViewController * sourceViewController, UIWebView * webView);
// 定义释放服务处理器类型 - [4.0.0]
typedef void (^WVJSBResetHandler)(UIViewController * sourceViewController, UIWebView * webView);
// 定义销毁服务处理器类型 - [4.0.0]
typedef void (^WVJSBDeallocHandler)(UIViewController * sourceViewController, UIWebView * webView);

@implementation AutoTestBlockCall

- (void)autoTestStart
{
    self.privateBlock =  ^NSString*(NSString *str){
        return [str stringByAppendingString:TEST_VALUE_STRING];
    };
    
    [self testCallBlockInLua];
    
    [self testStrBlock:^(NSString *code, NSString *responseData) {
        NSLog(@"code=%@ responseData=%@", code, responseData);
    } str:@"abc"];
    
    
    [self testLuaCallVoidBlock:^{
        NSLog(@"%s line=%d", __PRETTY_FUNCTION__, __LINE__);
    }];
    
    [self testLuaCallBlockWithTwoObjectParam:^(UIViewController *sourceViewController, UIWebView *webView) {
        NSLog(@"%s line=%d sourceViewController=%@ webView=%@", __PRETTY_FUNCTION__, __LINE__, sourceViewController, webView);
    }];
    
    [self test2LuaCallBlockWithTwoObjectParam:^(NSString *code, NSDictionary *responseData) {
        NSLog(@"%s line=%d code=%@ responseData=%@", __PRETTY_FUNCTION__, __LINE__, code, responseData);
    } str:@"abc"];
    
//    [self testIntBlock:^(int aInt, NSDictionary *responseData) {
//        NSLog(@"%s line=%d aInt=%d responseData=%@", __PRETTY_FUNCTION__, __LINE__, aInt, responseData);
//    }];

    [self testRecursiveBlock:^(id data, YYZJSBResponse yyzJSBResponseCallback, UIViewController *sourceViewController, UIWebView *webView) {
        NSLog(@"%s line=%d sourceViewController=%@ webView=%@", __PRETTY_FUNCTION__, __LINE__, sourceViewController, webView);
        yyzJSBResponseCallback(data, nil);
    } bBlock:^(NSString *code, NSDictionary *responseData) {
        NSLog(@"%s line=%d code=%@ responseData=%@", __PRETTY_FUNCTION__, __LINE__, code, responseData);
    }];
    
    
    
    [self testReturnObjectBlock:^NSString *(NSString *code, NSDictionary *responseData) {
        NSLog(@"%s line=%d code=%@ responseData=%@", __PRETTY_FUNCTION__, __LINE__, code, responseData);
        return [code stringByAppendingString:TEST_VALUE_STRING];
    }];
    //    return ;
    [self testReturnDictObjectBlock:^NSDictionary *(NSString *code, NSDictionary *responseData) {
        NSLog(@"%s line=%d code=%@ responseData=%@", __PRETTY_FUNCTION__, __LINE__, code, responseData);
        return @{@"key1": @"value1", @"key2":@"value2"};
    }];
    
    [self testReturnViewControllerObjectBlock:^UIViewController *(NSString *code, NSDictionary *responseData) {
        NSLog(@"%s line=%d code=%@ responseData=%@", __PRETTY_FUNCTION__, __LINE__, code, responseData);
        
        return [UIViewController new];
    } ];
    
    [self testLuaCallBlockReturnIntWith5ciqfd:^int(int i1, long long q2, float f3, double d4) {
        NSLog(@"i1=%d q2=%lld f3=%f d4=%f",i1, q2, f3, d4);
        NSLog(@"OC TEST SUCCESS: %s", "testLuaCallBlockReturnIntWith5ciqfd");
        return TEST_VALUE_INT;
    }];
    
    [self testReturnCGFloatWithFirstCGFloatBlock:^CGFloat(CGFloat aFirstCGFloat, BOOL aBOOL, NSInteger aInteger, CGFloat aCGFloat) {
        
        return TEST_VALUE_CGFLOAT;
    }];
    
    [self testReturnIntegerWithFirstIntegerBlock:^NSInteger(NSInteger aFirstInteger, BOOL aBOOL, CGFloat aCGFloat, id aId) {
        return TEST_VALUE_INTEGER;
    }];
}

//empty , code in lua
- (void)testCallBlockInLua{
    
}

- (void)testBlock:(void (^)(NSString * code, NSDictionary * responseData))response str:(NSString *)str{
    NSLog(@"testBlock str=%@", str);
    response(@"123", @{@"k1": @"v1", @"k2":@"v2"});
}

- (void)testStrBlock:(void (^)(NSString *stra, NSString *strb))response str:(NSString *)str{
    NSLog(@"testBlock str=%@", str);
    response(@"123", @"456");
}

- (void)testLuaCallVoidBlock:(void (^)())block{
    block();
}

- (void)testLuaCallBlockWithTwoObjectParam:(WVJSBResetHandler)response{
    UIWebView *webView = [[UIWebView alloc] init];
    response([UIViewController new], webView);
}

- (void)test2LuaCallBlockWithTwoObjectParam:(void (^)(NSString * code, NSDictionary * responseData))response str:(NSString *)str{
    NSLog(@"testBlock str=%@", str);
    response(@"123", @{@"k1": @"v1", @"k2":@"v2"});
}

- (void)testLuaCallBlockReturnIntWith5ciqfd:(int (^)(int, long long, float, double))block{
    int res = block(TEST_VALUE_INT, TEST_VALUE_LONG_LONG, TEST_VALUE_FLOAT, TEST_VALUE_DOUBLE);
    NSAssert(res == TEST_VALUE_INT, @"%s返回值错误", __PRETTY_FUNCTION__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

- (void)testRecursiveBlock:(WVJSBHandler)aBlock bBlock:(YYZJSBResponse)bBlock{
    UIWebView *webView = [[UIWebView alloc] init];
    aBlock(@"abc", bBlock, [UIViewController new], webView);
}

- (void)testReturnObjectBlock:(NSString* (^)(NSString * code, NSDictionary * responseData))response{
    NSString *res = response(@"123", @{@"k1": @"v1", @"k2":@"v2"});
    NSLog(@"res=%@", res);
}

- (void)testReturnDictObjectBlock:(NSDictionary* (^)(NSString * code, NSDictionary * responseData))response{
    NSDictionary *res = response(@"123", @{@"k1": @"v1", @"k2":@"v2"});
    NSLog(@"res=%@", res);
}

- (void)testReturnViewControllerObjectBlock:(UIViewController* (^)(NSString * code, NSDictionary * responseData))response{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *res = response(@"123", @{@"k1": @"v1", @"k2":@"v2"});
        NSLog(@"res=%@", res);
    });
}

#pragma mark float

- (void)testReturnCGFloatWithFirstCGFloatBlock:(CGFloat(^)(CGFloat aFirstCGFloat, BOOL aBOOL, NSInteger aInteger, CGFloat aCGFloat))block{
    CGFloat res = block(TEST_VALUE_CGFLOAT, TEST_VALUE_BOOL, TEST_VALUE_INTEGER,TEST_VALUE_CGFLOAT);
    NSLog(@"res=%f F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert([AutoTestUtil isDoubleEqual:res aDouble:TEST_VALUE_CGFLOAT], @"%s返回值错误", __PRETTY_FUNCTION__);
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

#pragma mark int

- (void)testReturnIntegerWithFirstIntegerBlock:(NSInteger(^)(NSInteger aFirstInteger, BOOL aBOOL, CGFloat aCGFloat, id aId))block{
    NSInteger res = block(TEST_VALUE_INTEGER, TEST_VALUE_BOOL,TEST_VALUE_CGFLOAT, self);
    NSLog(@"res=%ld F=%s LINE=%d", res, __PRETTY_FUNCTION__, __LINE__);
    NSAssert(res == TEST_VALUE_INTEGER, @"返回值错误");
    NSLog(@"OC TEST SUCCESS: %s", __PRETTY_FUNCTION__);
}

@end
