//
//  Structs.m
//  OinkTests
//
//  Created by ProbablyInteractive on 8/23/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "Structs.h"

@implementation Structs

+ (struct SimpleStruct)numberFive {
    struct SimpleStruct five;
    five.number = 5;
    
    return five;
}

+ (NSRange)rangeTwoTwenty {
    NSRange range;
    range.location = 2;
    range.length = 20;
    
    return range;
}

+ (struct CustomStruct)seventyPointFiveEighty {
    struct CustomStruct s;
    s.first = 70.5;
    s.second = 80;
    return s;
}

+ (BOOL)expectSix:(struct SimpleStruct)value {
    return value.number == 6;
}

+ (BOOL)expectsCGRectOneTwoThreeFour:(CGRect)rect {
    return rect.origin.x == 1 && rect.origin.y == 2 && rect.size.width == 3 && rect.size.height == 4;}

+ (BOOL)expectsCGRectTwoFourSixEight:(CGRect)rect {
    return rect.origin.x == 2 && rect.origin.y == 4 && rect.size.width == 6 && rect.size.height == 8;
}

+ (BOOL)expectsCustomStructFiftySixty:(struct CustomStruct)s {
    return s.first == 50 && s.second == 60;
}

@end
