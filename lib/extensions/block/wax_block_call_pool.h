//
//  wax_block_call_pool.h
// wax
//
//  Created by junzhan on 15-1-8.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "wax_define.h"
#import "lua.h"
#import <Foundation/Foundation.h>
extern void *lua_call_bb(lua_State *L, int index, char typeEncoding);

NSDictionary *wax_block_call_pool();
