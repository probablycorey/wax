//
// wax_block.m
// wax
//
//  Created by junzhan on 14-8-26.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//
#import "wax_helpers.h"
#import <CoreGraphics/CGBase.h>

NSString *wax_block_paramsTypeEncodingWithTypeArray(NSArray *paramsTypeArray){
    static NSDictionary *dict = nil;
    
    if(!dict){
        dict = [@{@"void":[NSString stringWithUTF8String:@encode(void)],
                  
                  @"BOOL":[NSString stringWithUTF8String:@encode(BOOL)],
                  @"bool":[NSString stringWithUTF8String:@encode(bool)],
                  
                  @"char":[NSString stringWithUTF8String:@encode(char)],
                  @"unsignedchar":[NSString stringWithUTF8String:@encode(unsigned char)],
                  
                  @"short":[NSString stringWithUTF8String:@encode(short)],
                  @"unsignedshort":[NSString stringWithUTF8String:@encode(unsigned short)],
                  
                  @"int":[NSString stringWithUTF8String:@encode(int)],
                  @"unsignedint":[NSString stringWithUTF8String:@encode(unsigned int)],
                  @"NSInteger":[NSString stringWithUTF8String:@encode(NSInteger)],//32:i 64:q
                  @"NSUInteger":[NSString stringWithUTF8String:@encode(NSUInteger)],//32:I 64:Q
                  
                  @"longlong":[NSString stringWithUTF8String:@encode(long long)],
                  @"unsignedlonglong":[NSString stringWithUTF8String:@encode(unsigned long long)],
                  
                  @"float":[NSString stringWithUTF8String:@encode(float)],
                  @"CGFloat":[NSString stringWithUTF8String:@encode(CGFloat)],
                  @"double":[NSString stringWithUTF8String:@encode(double)],
                  
                  @"char*":[NSString stringWithUTF8String:@encode(char*)],
                  @"void*":[NSString stringWithFormat:@"%c", WAX_TYPE_POINTER],//To simplify the only 1 pointer symbol
                  @"id":[NSString stringWithUTF8String:@encode(id)],
                  } retain];
        
    }
    //    NSLog(@"dict=%@", dict);
    NSMutableString *res = [NSMutableString string];
    for(NSString *paramsType in paramsTypeArray){
        paramsType = [paramsType stringByReplacingOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, paramsType.length)];//remove the space
        if([dict objectForKey:paramsType]){//find it
            [res appendString:[dict objectForKey:paramsType]];
        }else{
            if([paramsType rangeOfString:@"*"].location != NSNotFound){//Other pointer unified as ID type
                [res appendString:[dict objectForKey:@"id"]];
            }else{
                fprintf(stderr, "HOT %s:%d convert %s failed", __PRETTY_FUNCTION__, __LINE__, [paramsType UTF8String]);
                return nil;
            }
        }
    }
    return res;
}
