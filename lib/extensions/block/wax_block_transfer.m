//
//  WaxFunction.m
// wax
//
//  Created by junzhan on 14-8-15.
//  Copyright (c) 2014年 junzhan. All rights reserved.
//

#import "wax_block_transfer.h"
#import "wax_helpers.h"
#import "wax_instance.h"
#import "wax_struct.h"
#import "lauxlib.h"
#import "wax_lock.h"
#import "wax_block.h"
#import "wax_block_transfer_pool.h"
#import "wax_define.h"
extern lua_State *wax_currentLuaState();

#define LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, type, q) \
va_list args_copy;\
va_list args;\
va_start(args, q);\
va_copy(args_copy, args);\
void *returnBuffer = luaBlockARM32ReturnBufferWithParamsTypeEncoding(paramsTypeEncoding, self, &q, args_copy);\
type res = (type)0;\
if(returnBuffer){\
    res = *((type*)returnBuffer);\
}\
free(returnBuffer);\
return res;\

@implementation WaxFunction // Used to pass lua fuctions around

- (void)dealloc{
//    NSLog(@"dealloc=%@", self);
    [super dealloc];
}

#pragma mark return void & param void
//all void
-(void (^)())luaVoidBlock {//blockzh
    return [[^() {
        [wax_globalLock() lock];
        lua_State *L = wax_currentLuaState();
        wax_fromInstance(L, self);
        lua_call(L, 0, 0);
        [wax_globalLock() unlock];
    } copy] autorelease];
}


#pragma mark return any & param void
-(LongLong (^)())luaBlockReturnLongLongWithVoidParam:(NSString *)paramsTypeEncoding {
    return [[^() {
        [wax_globalLock() lock];
        lua_State *L = wax_currentLuaState();
        wax_fromInstance(L, self);
        
        void *retValue = nil;
        const char *cParamsTypeEncoding = [paramsTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding];
        if(cParamsTypeEncoding[0] == WAX_TYPE_VOID){//return void
            lua_call(L, 0, 0);
        }else{
            lua_call(L, 0, 1);
            switch (cParamsTypeEncoding[0]) {
                case WAX_TYPE_INT:
                    if(lua_isnumber(L, -1)){
                        NSInteger res = lua_tointeger(L, -1);
                        retValue = (void*)res;
                    }
                    break;
                case WAX_TYPE_STRING:
                    if(lua_isstring(L, -1)){
                        const char *str = lua_tostring(L, -1);
                        retValue = (void*)str;
                    }
                    break;
                case WAX_TYPE_ID://id maybe NSString
                    if(lua_isuserdata(L, -1)){
                        wax_instance_userdata *userdata = lua_touserdata(L, -1);
                        retValue = userdata->instance;
                    }
                    if(lua_isstring(L, -1)){
                        const char *str = lua_tostring(L, -1);
                        retValue = (void*)[NSString stringWithCString:str  encoding:NSUTF8StringEncoding];
                    }
                    break;
                default:
                    NSLog(@"Unable to convert Obj-C type with type description '%s'", cParamsTypeEncoding);
                    break;
            }

        }
        [wax_globalLock() unlock];
        return retValue;
    } copy] autorelease];
}

-(float (^)())luaBlockReturnFloatWithVoidParam:(NSString *)paramsTypeEncoding {
    return [[^() {
        [wax_globalLock() lock];
        lua_State *L = wax_currentLuaState();
        wax_fromInstance(L, self);
        
        const char *cParamsTypeEncoding = [paramsTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding];
        lua_call(L, 0, 1);
        float retValue = 0;
        switch (cParamsTypeEncoding[0]) {
            case WAX_TYPE_FLOAT:
                if(lua_isnumber(L, -1)){
                    double res = lua_tonumber(L, -1);
                    retValue = res;
                }
                break;
            default:
                NSLog(@"Unable to convert Obj-C type with type description '%s'", cParamsTypeEncoding);
                break;
        }
        [wax_globalLock() unlock];
        return retValue;
    } copy] autorelease];
}

-(double (^)())luaBlockReturnDoubleWithVoidParam:(NSString *)paramsTypeEncoding {
    return [[^() {
        [wax_globalLock() lock];
        lua_State *L = wax_currentLuaState();
        wax_fromInstance(L, self);
        
        const char *cParamsTypeEncoding = [paramsTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding];
        lua_call(L, 0, 1);
        double retValue = 0;
        switch (cParamsTypeEncoding[0]) {
            case WAX_TYPE_DOUBLE:
                if(lua_isnumber(L, -1)){
                    double res = lua_tonumber(L, -1);
                    retValue = res;
                }
                break;
            default:
                NSLog(@"Unable to convert Obj-C type with type description '%s'", cParamsTypeEncoding);
                break;
        }
        [wax_globalLock() unlock];
        return retValue;
    } copy] autorelease];
}

#pragma mark all 32 bit block

void* luaBlockARM32ReturnBufferWithParamsTypeEncoding(NSString *paramsTypeEncoding, id self, void* firstParam, va_list args){
    [wax_globalLock() lock];
    
    
    void *returnBuffer = nil;
    
    const char *cParamsTypeEncoding = [paramsTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding];
    int paramNum = (int)paramsTypeEncoding.length;
    lua_State *L = wax_currentLuaState();
    wax_fromInstance(L, self);//push self

    if(firstParam){//push first param
        char tempTypeEncoding[3] = {0};
        tempTypeEncoding[0] = cParamsTypeEncoding[1];
        wax_fromObjc(L, tempTypeEncoding, firstParam);
    }
    
    //push后面的所有参数
    void *paramBuffer = NULL;
    char tempTypeEncoding[3] = {0};
    for(int i = 2; i < paramNum; ++i){
        tempTypeEncoding[0] = cParamsTypeEncoding[i];
        void *buffer = 0;
        switch (tempTypeEncoding[0]) {
            case WAX_TYPE_VOID:
            {
                break;
            }
            case WAX_TYPE_POINTER:
            {
                void *arg = va_arg(args, void*);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_CHAR:
            {
                char arg = va_arg(args, char);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_SHORT:
            {
                short arg = va_arg(args, short);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_INT:
            {
                int arg = va_arg(args, int);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_UNSIGNED_CHAR:
            {
                unsigned char arg = va_arg(args, unsigned char);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_UNSIGNED_INT:
            {
                unsigned int arg = va_arg(args, unsigned int);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_UNSIGNED_SHORT:
            {
                unsigned short arg = va_arg(args, unsigned short);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_LONG:
            {
                long arg = va_arg(args, long);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_LONG_LONG:
            {
                long long arg = va_arg(args, long long);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_UNSIGNED_LONG:
            {
                unsigned long arg = va_arg(args, unsigned long);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_UNSIGNED_LONG_LONG:
            {
                unsigned long long arg = va_arg(args, unsigned long long);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_FLOAT://这个不能用double
            {
                float arg = va_arg(args, float);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_DOUBLE:
            {
                double arg = va_arg(args, double);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_C99_BOOL:
            {
                BOOL arg = va_arg(args, BOOL);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_STRING:
            {
                char * arg = va_arg(args, char *);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_ID:
            {
                id arg = va_arg(args, id);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_SELECTOR:
            {
                SEL arg = va_arg(args, SEL);
                buffer = &arg;
                break;
            }
            case WAX_TYPE_CLASS:
            {
                id arg = va_arg(args, id);
                buffer = &arg;
                break;
            }
                
            default:
                luaL_error(L, "Unable to convert Obj-C type with type description '%s'", tempTypeEncoding);
                break;
        }
        paramBuffer = buffer;
        wax_fromObjc(L, tempTypeEncoding, paramBuffer);
    }

    va_end(args);
    
    if(cParamsTypeEncoding[0] == WAX_TYPE_VOID){//return void
        lua_call(L, paramNum-1, 0);
    }else{
        lua_call(L, paramNum-1, 1);
        char returnType = cParamsTypeEncoding[0];
        char tempTypeEncoding[3] = {returnType,0};
        returnBuffer = wax_copyToObjc(L, tempTypeEncoding, -1, nil);
    }
    [wax_globalLock() unlock];
    return returnBuffer;
    
}



#pragma mark 32位 return LongLong

- (LongLong (^)(int p, ...))luaBlockReturnLongLongWithFirstIntParamTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^LongLong(int q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, LongLong, q);
    } copy] autorelease];
}

- (LongLong (^)(LongLong p, ...))luaBlockReturnLongLongWithFirstLongLongParamTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^LongLong(LongLong q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, LongLong, q);
    } copy] autorelease];
}

- (LongLong (^)(float p, ...))luaBlockReturnLongLongWithFirstFloatParamTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^LongLong(float q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, LongLong, q);
    } copy] autorelease];
}

- (LongLong (^)(double p, ...))luaBlockReturnLongLongWithFirstDoubleParamTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^LongLong(double q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, LongLong, q);
    } copy] autorelease];
}

#pragma mark 32位 return float
- (float (^)(int p, ...))luaBlockReturnFloatWithFirstIntParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^float(int q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, float, q);
        return res;
    } copy] autorelease];
}

- (float (^)(LongLong p, ...))luaBlockReturnFloatWithFirstLongLongParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^float(LongLong q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, float, q);
    } copy] autorelease];
}

- (float (^)(float p, ...))luaBlockReturnFloatWithFirstFloatParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^float(float q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, float, q);
    } copy] autorelease];
}

- (float (^)(double p, ...))luaBlockReturnFloatWithFirstDoubleParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^float(double q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, float, q);
    } copy] autorelease];
}

#pragma mark 32位 return double
- (double (^)(int p, ...))luaBlockReturnDoubleWithFirstIntParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^double(int q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, double, q);
    } copy] autorelease];
}

- (double (^)(LongLong p, ...))luaBlockReturnDoubleWithFirstLongLongParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^double(LongLong q, ...){
    LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, double, q);
    } copy] autorelease];
}

- (double (^)(float p, ...))luaBlockReturnDoubleWithFirstFloatParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^double(float q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, double, q);
    } copy] autorelease];
}

- (double (^)(double p, ...))luaBlockReturnDoubleWithFirstDoubleParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    return [[^double(double q, ...){
        LUA_BLOCK_CALL_ARM32_RETURN_BUFFER(paramsTypeEncoding, double, q);
    } copy] autorelease];
}


#pragma mark tool method

//block all call this method
- (id)luaBlockWithParamsTypeEncoding:(NSString *)paramsTypeEncoding{

    
#if WAX_IS_ARM_64 == 1
    return luaBlockARM64WithParamsTypeEncoding(paramsTypeEncoding, self);

#else
    const char *tempStr = [paramsTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger paramLen = paramsTypeEncoding.length;
    if(paramLen == 0){
        return [self luaVoidBlock];
    }
    if(tempStr[0] == WAX_TYPE_FLOAT){//返回float
        if(paramLen == 1){
            return [self luaBlockReturnFloatWithVoidParam:paramsTypeEncoding];
        }
        if(tempStr[1] == WAX_TYPE_FLOAT){
            return [self luaBlockReturnFloatWithFirstFloatParamsTypeEncoding:paramsTypeEncoding];
        }else if(tempStr[1] == WAX_TYPE_DOUBLE){
            return [self luaBlockReturnFloatWithFirstDoubleParamsTypeEncoding:paramsTypeEncoding];
        }else if([self isFirstParamNeedLongLong:tempStr[1]]){
            return [self luaBlockReturnFloatWithFirstLongLongParamsTypeEncoding:paramsTypeEncoding];
        }else{
            return [self luaBlockReturnFloatWithFirstIntParamsTypeEncoding:paramsTypeEncoding];
        }
    }else if(tempStr[0] == WAX_TYPE_DOUBLE){//返回double
        if(paramLen == 1){
            return [self luaBlockReturnDoubleWithVoidParam:paramsTypeEncoding];
        }
        if(tempStr[1] == WAX_TYPE_FLOAT){
            return [self luaBlockReturnDoubleWithFirstFloatParamsTypeEncoding:paramsTypeEncoding];
        }else if(tempStr[1] == WAX_TYPE_DOUBLE){
            return [self luaBlockReturnDoubleWithFirstDoubleParamsTypeEncoding:paramsTypeEncoding];
        }else if([self isFirstParamNeedLongLong:tempStr[1]]){
            return [self luaBlockReturnDoubleWithFirstLongLongParamsTypeEncoding:paramsTypeEncoding];
        }else{
            return [self luaBlockReturnDoubleWithFirstIntParamsTypeEncoding:paramsTypeEncoding];
        }
    }else{
        if(paramLen == 1){//返回char,bool,整数
            return [self luaBlockReturnLongLongWithVoidParam:paramsTypeEncoding];
        }
        if(tempStr[1] == WAX_TYPE_FLOAT){
            return [self luaBlockReturnLongLongWithFirstFloatParamTypeEncoding:paramsTypeEncoding];
        }else if(tempStr[1] == WAX_TYPE_DOUBLE){
            return [self luaBlockReturnLongLongWithFirstDoubleParamTypeEncoding:paramsTypeEncoding];
        }else if([self isFirstParamNeedLongLong:tempStr[1]]){
            return [self luaBlockReturnLongLongWithFirstLongLongParamTypeEncoding:paramsTypeEncoding];
        }else{
            return [self luaBlockReturnLongLongWithFirstIntParamTypeEncoding:paramsTypeEncoding];
        }
    }
#endif
    return nil;
}


- (id)luaBlockWithParamsTypeArray:(NSArray *)paramsTypeArray{
    NSString *paramsTypeEncoding = wax_block_paramsTypeEncodingWithTypeArray(paramsTypeArray);
    return [self luaBlockWithParamsTypeEncoding:paramsTypeEncoding];
}

//test function
- (id) luaBlockReturnLongLongWithAllFixedParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    
    return [[^LongLong(LongLong aFirstLongLong, LongLong aBOOL, LongLong aBool, LongLong aChar, LongLong aCharPointer, LongLong aShort, LongLong aInt, LongLong aInteger, LongLong aUInteger, LongLong aLongLong, LongLong aULongLong, double aFloat, double aCGFloat, double aDouble, LongLong aVoidPointer, LongLong aString, LongLong aId){
        
        void *returnBuffer = luaBlockARM64ReturnBufferWithParamsTypeEncoding(paramsTypeEncoding, self, &aFirstLongLong,  &aBOOL, &aBool, &aChar,&aCharPointer, &aShort, &aInt, &aInteger, &aUInteger, &aLongLong, &aULongLong, &aFloat, &aCGFloat, &aDouble,&aVoidPointer, &aString, &aId);
        LongLong res = 0;
        if(returnBuffer){
            res = *((LongLong*)returnBuffer);
        }
        return res;
    }copy] autorelease];
}


- (id) luaBlockReturnDoubleWithAllFixedParamsTypeEncoding:(NSString *)paramsTypeEncoding{
    
    return [[^double(LongLong aFirstLongLong, LongLong aBOOL, LongLong aBool, LongLong aChar, LongLong aCharPointer, LongLong aShort, LongLong aInt, LongLong aInteger, LongLong aUInteger, LongLong aLongLong, LongLong aULongLong, double aFloat, double aCGFloat, double aDouble, LongLong aVoidPointer, LongLong aString, LongLong aId){
        
        void *returnBuffer = luaBlockARM64ReturnBufferWithParamsTypeEncoding(paramsTypeEncoding, self, &aFirstLongLong,  &aBOOL, &aBool, &aChar,&aCharPointer, &aShort, &aInt, &aInteger, &aUInteger, &aLongLong, &aULongLong, &aFloat, &aCGFloat, &aDouble,&aVoidPointer, &aString, &aId);
        double res = 0;
        if(returnBuffer){
            res = *((double*)returnBuffer);
        }
        return res;
    }copy] autorelease];
}


- (BOOL)isFirstParamNeedLongLong:(char)type{
    BOOL res = NO;
    //arm64 pointer  as longlong
#if WAX_IS_ARM_64 == 1
    res = (type == WAX_TYPE_LONG_LONG || type == WAX_TYPE_UNSIGNED_LONG_LONG ||
                type == WAX_TYPE_STRING || type == WAX_TYPE_POINTER ||
                type == WAX_TYPE_ID);
#else
    res = (type == WAX_TYPE_LONG_LONG || type == WAX_TYPE_UNSIGNED_LONG_LONG);
#endif
    return res;
}
#pragma mark other

@end


#pragma mark c api

void* luaBlockARM64ReturnBufferWithParamsTypeEncoding(NSString *paramsTypeEncoding, id self, ...){
    [wax_globalLock() lock];
    
    void *returnBuffer = nil;
    
    const char *cParamsTypeEncoding = [paramsTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding];
    int paramNum = (int)paramsTypeEncoding.length;
    lua_State *L = wax_currentLuaState();
    wax_fromInstance(L, self);//push self
    
    va_list args;
    va_start(args, self);
    
    for(int i = 1; i < paramNum; ++i){//push all parameters.(attention:the 0 item is return value)
        char tempTypeEncoding[3] = {0};
        tempTypeEncoding[0] = cParamsTypeEncoding[i];
        void *buffer = va_arg(args, void*);
        wax_fromObjc(L, tempTypeEncoding, buffer);
    }
    va_end(args);
    
    if(cParamsTypeEncoding[0] == WAX_TYPE_VOID){//return void
        lua_call(L, paramNum-1, 0);
    }else{
        lua_call(L, paramNum-1, 1);
        char returnType = cParamsTypeEncoding[0];
        char tempTypeEncoding[3] = {returnType,0};
        returnBuffer = wax_copyToObjc(L, tempTypeEncoding, -1, nil);
    }
    [wax_globalLock() unlock];
    return returnBuffer;
}

#if WAX_IS_ARM_64 == 1
id luaBlockARM64WithParamsTypeEncoding(NSString *typeEncoding, id self){
    
    NSArray *doubleArray = @[@"f", @"d"];
    NSMutableString *newTypeEncoding = [NSMutableString string];
    for(NSUInteger i = 0; i < typeEncoding.length; ++i){
        NSString *tempType = [typeEncoding substringWithRange:NSMakeRange(i, 1)];
        if([doubleArray containsObject:tempType]){
            [newTypeEncoding appendString:@"d"];//float,double
        }else{
            [newTypeEncoding appendString:@"q"];//as long long
        }
    }
    NSValue *value = [wax_block_transfer_pool() objectForKey:newTypeEncoding];
    if(!value){
        NSLog(@"can't find block imp with typeEncoding %@", typeEncoding);
        return nil;
    }
    
    id (*luaBlockARM64Imp)(NSString *, id) = [value pointerValue];
    
    id luaBlockARM64 = luaBlockARM64Imp(typeEncoding, self);//call orginal typeEncoding
    return luaBlockARM64;
}
#endif
