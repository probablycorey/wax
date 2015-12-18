//
// wax_config.m
// wax
//
//  Created by junzhan on 14-9-25.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//

#import "wax_config.h"
#import "wax_helpers.h"
#import "wax_gc.h"
#import "wax_capi.h"

static NSDictionary *configDict;

int luaSetWaxConfig(lua_State *L){
    if(lua_isnil(L, -1)){
        return 0;
    }else{
        id *instancePointer = wax_copyToObjc(L, "@", -1, nil);
        id instance = *(id *)instancePointer;
        
        if([instance isKindOfClass:[NSDictionary class]]){
            [configDict release];
            configDict = [instance copy];//save
            
            if([instance objectForKey:@"gc_timeout"]){//gc time
                [wax_gc setWaxGCTimeout:[[instance objectForKey:@"gc_timeout"] integerValue]];
            }else if([instance objectForKey:@"openBindOCFunction"]){
                wax_openBindOCFunction(L);
            }
        }
        free(instancePointer);
    }
    return 0;
}

NSDictionary *luaGetWaxConfig(){
    return configDict;
}
