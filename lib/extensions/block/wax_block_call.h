//
// wax_block_call.h
// wax
//
//  Created by junzhan on 15-1-8.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//  32&64都可用

#import <Foundation/Foundation.h>
#import "lua.h"

#pragma mark call from lua



/**
    lua code call OC block（0~4 OC object param，return any type). 
    OC code: int res = block(123, 1234567890123, 123.456, 1234.567);
 *  lua code: local res = luaCallBlockWithParamsTypeArray(block, {"int","int", "long long", "float", "double"}, 123, 1234567890123, 123.456, 1234.567);
    attention:The first value in the array is return type
 */
int luaCallBlockWithParamsTypeArray(lua_State *L);


int luaCallBlock(lua_State *L);


#pragma mark call from c

void *lua_call_bb(lua_State *L, int index, char typeEncoding);