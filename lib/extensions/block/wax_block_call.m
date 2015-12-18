//
// wax_block_call.m
// wax
//
//  Created by junzhan on 15-1-8.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

#import "wax_block_call.h"
#import "wax_block_call_pool.h"
#import "wax.h"
#import "wax_instance.h"
#import "wax_helpers.h"
#import "wax_block.h"
#import "wax_define.h"
#import "wax_block_description.h"
id wax_block_call_objectFromLuaState(lua_State *L, int index){
    if(lua_isnil(L, index)){
        return nil;
    }else{
        id *instancePointer = wax_copyToObjc(L, "@", index, nil);
        id instance = *(id *)instancePointer;
        free(instancePointer);
        return instance;
    }
}
int luaCallBlockReturnVoidWithObjectParam(lua_State *L){
    int n = lua_gettop(L);
    wax_instance_userdata *block = lua_touserdata(L, -n);
    switch (n) {
        case 1:
        {
            void (^y)()  = block->instance;
            y();
        }
            break;
        case 2:
        {
            void (^y)(id)  = block->instance;
            y(wax_block_call_objectFromLuaState(L, -1));
        }
            break;
        case 3:
        {
            void (^y)(id, id)  = block->instance;
            y(wax_block_call_objectFromLuaState(L, -2), wax_block_call_objectFromLuaState(L, -1));
        }
            break;
        case 4:
        {
            void (^y)(id, id, id)  = block->instance;
            y(wax_block_call_objectFromLuaState(L, -3), wax_block_call_objectFromLuaState(L, -2), wax_block_call_objectFromLuaState(L, -1));
        }
            break;
        case 5:
        {
            void (^y)(id, id, id, id)  = block->instance;
            y(wax_block_call_objectFromLuaState(L, -4), wax_block_call_objectFromLuaState(L, -3), wax_block_call_objectFromLuaState(L, -2), wax_block_call_objectFromLuaState(L, -1));
        }
            break;
        case 6:
        {
            void (^y)(id, id, id, id, id)  = block->instance;
            y(wax_block_call_objectFromLuaState(L, -5), wax_block_call_objectFromLuaState(L, -4), wax_block_call_objectFromLuaState(L, -3), wax_block_call_objectFromLuaState(L, -2), wax_block_call_objectFromLuaState(L, -1));
        }
            break;
            
        default:
            break;
    }
    return 0;
}

int luaCallBlockReturnObjectWithObjectParam(lua_State *L){
    int n = lua_gettop(L);
    wax_instance_userdata *block = lua_touserdata(L, -n);
    id res = nil;
    switch (n) {
        case 1:
        {
            id (^y)()  = block->instance;
            res = y();
        }
            break;
        case 2:
        {
            id (^y)(id)  = block->instance;
            res = y(wax_block_call_objectFromLuaState(L, -1));
        }
            break;
        case 3:
        {
            id (^y)(id, id)  = block->instance;
            res = y(wax_block_call_objectFromLuaState(L, -2), wax_block_call_objectFromLuaState(L, -1));
        }
            break;
        case 4:
        {
            id (^y)(id, id, id)  = block->instance;
            res = y(wax_block_call_objectFromLuaState(L, -3), wax_block_call_objectFromLuaState(L, -2), wax_block_call_objectFromLuaState(L, -1));
        }
            break;
        case 5:
        {
            id (^y)(id, id, id, id)  = block->instance;
            res = y(wax_block_call_objectFromLuaState(L, -4), wax_block_call_objectFromLuaState(L, -3), wax_block_call_objectFromLuaState(L, -2), wax_block_call_objectFromLuaState(L, -1));
        }
            break;
        case 6:
        {
            id (^y)(id, id, id, id, id)  = block->instance;
            res = y(wax_block_call_objectFromLuaState(L, -5), wax_block_call_objectFromLuaState(L, -4), wax_block_call_objectFromLuaState(L, -3), wax_block_call_objectFromLuaState(L, -2), wax_block_call_objectFromLuaState(L, -1));
        }
            break;
            
        default:
            break;
    }
    wax_fromInstance(L, res);
    return 1;
}

void *lua_call_bb(lua_State *L, int index, char typeEncoding){
    char tempTypeEncoding[3] = {0};//at least 3 byte, or wax_simplifyTypeDescription maybe out of bounds
    tempTypeEncoding[0] = typeEncoding;
    void *returnBuffer = wax_copyToObjc(L, tempTypeEncoding, index, nil);
    //    free(returnBuffer);//Release will cause loss of data. TODO
    return returnBuffer;
}

int luaCallBlockWithParamsTypeArray(lua_State *L){
    int n = lua_gettop(L);
    int st = 2;//1:block, 2:typeArray
    wax_instance_userdata *blockUserData = lua_touserdata(L, 1);
    
    id *instancePointer = wax_copyToObjc(L, "@", 2, nil);
    NSArray *paramsTypeArray = *(id *)instancePointer;
    free(instancePointer);
    
    NSString *paramsTypeEncoding = wax_block_paramsTypeEncodingWithTypeArray(paramsTypeArray);
    
    const char *origTypeEncoding = [paramsTypeEncoding UTF8String];
    unsigned long length = strlen(origTypeEncoding);
    
    char *newTypeEncoding = alloca(sizeof(char)*length);
    strcpy(newTypeEncoding, origTypeEncoding);
    
    for(NSUInteger i = 0; i < length; ++i){
        char tempChar = newTypeEncoding[i];
        if(tempChar == WAX_TYPE_FLOAT || tempChar == WAX_TYPE_DOUBLE){//float,double
            continue ;
        }else if(tempChar == WAX_TYPE_INT || tempChar == WAX_TYPE_UNSIGNED_INT){
            newTypeEncoding[i] = WAX_TYPE_INT;//WAX_TYPE_UNSIGNED_INT as int
        }else if(tempChar == WAX_TYPE_LONG_LONG || tempChar == WAX_TYPE_UNSIGNED_LONG_LONG){
            newTypeEncoding[i] = WAX_TYPE_LONG_LONG;//WAX_TYPE_UNSIGNED_LONG_LONG as longlong
        }else if(tempChar == WAX_TYPE_POINTER || tempChar == WAX_TYPE_STRING || tempChar == WAX_TYPE_ID){//pointer
#if WAX_IS_ARM_64 == 1
            newTypeEncoding[i] = WAX_TYPE_LONG_LONG;
#else
            newTypeEncoding[i] = WAX_TYPE_INT;
#endif
        }else{//other all 32 bit as int, 64 bit as longlong
#if WAX_IS_ARM_64 == 1
            newTypeEncoding[i] = WAX_TYPE_LONG_LONG;
#else
            newTypeEncoding[i] = WAX_TYPE_INT;
#endif
        }
    }
    
    NSValue *value = [wax_block_call_pool() objectForKey:[NSString stringWithUTF8String:newTypeEncoding]];
    NSCAssert(value, @"can't match block luaCallBlockWithParamsTypeEncoding");
    if(!value){
//        NSLog(@"can't match block luaCallBlockWithParamsTypeEncoding");
        return 0;
    }
    
    void* (*luaBlockCallBuffer)(lua_State *L, id block, int st, const char *te) = [value pointerValue];
    
    void *returnBuffer = luaBlockCallBuffer(L, blockUserData->instance, st, origTypeEncoding);
    
    //original type
    char tempTypeEncoding[3] = {0};//at least 3 byte, or wax_simplifyTypeDescription maybe out of bounds
    tempTypeEncoding[0] = origTypeEncoding[0];
    wax_fromObjc(L, tempTypeEncoding, returnBuffer);
    return 1;
}

int luaCallBlock(lua_State *L){
    int n = lua_gettop(L);
    wax_instance_userdata *blockUserData = lua_touserdata(L, 1);
    id block = blockUserData->instance;
    int paramNum = n-1;
    
    WaxBlockDescription *blockDesc = [[WaxBlockDescription alloc] initWithBlock:block];
    NSMethodSignature *blockSignature = blockDesc.blockSignature;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:blockSignature];
    [invocation setTarget:block];
    NSCAssert(blockSignature.numberOfArguments == paramNum+1, @"blockSignature.numberOfArguments != paramNum");
    
    void **arguements = calloc(sizeof(void*), paramNum);
    
    for(int i = 1; i <= paramNum; ++i){//0 is block:@?, param start from 1
        const char *type = [blockSignature getArgumentTypeAtIndex:i];
        void *buffer = wax_copyToObjc(L, type, 1+i, nil);
        arguements[i-1] = buffer;
        [invocation setArgument:buffer atIndex:i];
    }
    
    [invocation invoke];
    
    for (int i = 0; i < paramNum; i++) {//free arguments memory
        free(arguements[i]);
    }
    free(arguements);
    
    if(blockSignature.methodReturnLength > 0){
        void *buffer = malloc(blockSignature.methodReturnLength);
        [invocation getReturnValue:buffer];
        wax_fromObjc(L, blockSignature.methodReturnType, buffer);
        free(buffer);
    }
    
    [blockDesc release];
    return blockSignature.methodReturnLength > 0;
}
