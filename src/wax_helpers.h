//
//  oink_helpers.h
//  Lua
//
//  Created by ProbablyInteractive on 5/18/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import "oink_instance.h"

#import "lua.h"

//#define _C_ATOM     '%'
//#define _C_VECTOR   '!'
//#define _C_CONST    'r'

// ENCODINGS CAN BE FOUND AT http://developer.apple.com/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
#define OINK_TYPE_CHAR _C_CHR
#define OINK_TYPE_INT _C_INT
#define OINK_TYPE_SHORT _C_SHT
#define OINK_TYPE_UNSIGNED_CHAR _C_UCHR
#define OINK_TYPE_UNSIGNED_INT _C_UINT
#define OINK_TYPE_UNSIGNED_SHORT _C_USHT

#define OINK_TYPE_LONG _C_LNG
#define OINK_TYPE_LONG_LONG _C_LNG_LNG
#define OINK_TYPE_UNSIGNED_LONG _C_ULNG
#define OINK_TYPE_UNSIGNED_LONG_LONG _C_ULNG_LNG
#define OINK_TYPE_FLOAT _C_FLT
#define OINK_TYPE_DOUBLE _C_DBL

#define OINK_TYPE_C99_BOOL _C_BOOL

#define OINK_TYPE_STRING _C_CHARPTR
#define OINK_TYPE_VOID _C_VOID
#define OINK_TYPE_ARRAY _C_ARY_B
#define OINK_TYPE_ARRAY_END _C_ARY_E
#define OINK_TYPE_BITFIELD _C_BFLD
#define OINK_TYPE_ID _C_ID
#define OINK_TYPE_CLASS _C_CLASS
#define OINK_TYPE_SELECTOR _C_SEL
#define OINK_TYPE_STRUCT _C_STRUCT_B
#define OINK_TYPE_STRUCT_END _C_STRUCT_E
#define OINK_TYPE_UNION _C_UNION_B
#define OINK_TYPE_UNION_END _C_UNION_E
#define OINK_TYPE_POINTER _C_PTR
#define OINK_TYPE_UNKNOWN _C_UNDEF

#define OINK_PROTOCOL_TYPE_CONST 'r'
#define OINK_PROTOCOL_TYPE_IN 'n'
#define OINK_PROTOCOL_TYPE_INOUT 'N'
#define OINK_PROTOCOL_TYPE_OUT 'o'
#define OINK_PROTOCOL_TYPE_BYCOPY 'O'
#define OINK_PROTOCOL_TYPE_BYREF 'R'
#define OINK_PROTOCOL_TYPE_ONEWAY 'V'

#define BEGIN_STACK_MODIFY(L) int __startStackIndex = lua_gettop((L));

#define END_STACK_MODIFY(L, i) while(lua_gettop((L)) > (__startStackIndex + i)) lua_remove(L, __startStackIndex + 1);

#ifndef LOG_FLAGS
    #define LOG_FLAGS 0
#endif

#define LOG_GC 1

// This struct seem unnessessary
typedef struct _oink_selectors {
    SEL selectors[2];
} oink_selectors;

// Debug Helpers
void oink_printStack(lua_State *L);
void oink_printStackAt(lua_State *L, int i);
void oink_printTable(lua_State *L, int t);
void oink_log(int flag, NSString *format, ...);

// Convertion Helpers
int oink_fromObjc(lua_State *L, const char *typeDescription, void *buffer);
void oink_fromInstance(lua_State *L, id instance);
void oink_fromStruct(lua_State *L, const char *typeDescription, void *buffer);
    
void *oink_copyToObjc(lua_State *L, const char *typeDescription, int stackIndex, int *outsize);

// Misc Helpers
oink_selectors oink_selectorsForName(const char *methodName);
SEL oink_selectorForInstance(oink_instance_userdata *instanceUserdata, const char *methodName, BOOL forceInstanceCheck);
void oink_pushMethodNameFromSelector(lua_State *L, SEL selector);
BOOL oink_isInitMethod(const char *methodName);

const char *oink_removeProtocolEncodings(const char *type_descriptions);

int oink_sizeOfTypeDescription(const char *full_type_description);
int oink_simplifyTypeDescription(const char *in, char *out);

int oink_errorFunction(lua_State *L);
int oink_pcall(lua_State *L, int argumentCount, int returnCount);