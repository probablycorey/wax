//
//  WaxFunction.h
// wax
//
//  Created by junzhan on 14-8-15.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//  attention:when lua convert to OC block, must first use toobjc, then call WaxFunction's method, like: toobjc(function xxx end):luaVoidBlock()

#import <Foundation/Foundation.h>

@interface WaxFunction : NSObject
/**
 *  return value and param are all void
 */
-(void (^)())luaVoidBlock;


/**
 *  convert to OC block with return value and param's type.
 *  OC code: 
     [self testReturnIdWithFirstIdBlock:^id(id aFirstId, char *aCharPointer, char aChar, short aShort, int aInt, long long aLongLong, float aFloat, double aDouble, bool aBool, NSString *aString, id aId) {
        NSLog(@"aFirstId=%@", aFirstId);
        return @"123";
     }];
 * lua code:
	self:testReturnIdWithFirstIdBlock(
        toobjc(
            function(aFirstId, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
            print("aFirstId=" .. tostring(aFirstId))
            return aFirstId
        end
        ):luaBlockWithParamsTypeArray({"id","id", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
	)
 *
 *  @param paramsTypeArray params's type
 *
 *  @return a block
 */
- (id)luaBlockWithParamsTypeArray:(NSArray *)paramsTypeArray;
@end

#pragma mark call from c
void* luaBlockARM64ReturnBufferWithParamsTypeEncoding(NSString *paramsTypeEncoding, id self, ...);

id luaBlockARM64WithParamsTypeEncoding(NSString *typeEncoding, id self);

