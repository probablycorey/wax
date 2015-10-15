//
//  AutoTestUtil.h
//  
//
//  Created by junzhan on 15-4-16.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoTestUtil : NSObject


#pragma mark use
+ (void)runLuaFileInBundle:(NSString *)fileName;

+ (BOOL)isDoubleEqual:(double)firstDouble aDouble:(double)aDouble;

@end
