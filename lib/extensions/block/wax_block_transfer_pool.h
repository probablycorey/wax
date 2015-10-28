//
// wax_block_transfer.h
// wax
//
//  Created by junzhan on 15-1-6.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//  Only for 64 block adapter
#import "wax_define.h"
#import <Foundation/Foundation.h>
extern void* luaBlockARM64ReturnBufferWithParamsTypeEncoding(NSString *paramsTypeEncoding, id self, ...);

NSDictionary *wax_block_transfer_pool();