//
//  ObjLua_Helpers.h
//  Lua
//
//  Created by ProbablyInteractive on 5/18/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import "ObjLua_Instance.h"

#import "lua.h"

//#define _C_ATOM     '%'
//#define _C_VECTOR   '!'
//#define _C_CONST    'r'

#define OBJLUA_TYPE_CHAR _C_CHR
#define OBJLUA_TYPE_INT _C_INT
#define OBJLUA_TYPE_SHORT _C_SHT
#define OBJLUA_TYPE_UNSIGNED_CHAR _C_UCHR
#define OBJLUA_TYPE_UNSIGNED_INT _C_UINT
#define OBJLUA_TYPE_UNSIGNED_SHORT _C_USHT

#define OBJLUA_TYPE_LONG _C_LNG
#define OBJLUA_TYPE_LONG_LONG _C_LNG_LNG
#define OBJLUA_TYPE_UNSIGNED_LONG _C_ULNG
#define OBJLUA_TYPE_UNSIGNED_LONG_LONG _C_ULNG_LNG
#define OBJLUA_TYPE_FLOAT _C_FLT
#define OBJLUA_TYPE_DOUBLE _C_DBL

#define OBJLUA_TYPE_C99_BOOL _C_BOOL

#define OBJLUA_TYPE_STRING _C_CHARPTR
#define OBJLUA_TYPE_VOID _C_VOID
#define OBJLUA_TYPE_ARRAY _C_ARY_B
#define OBJLUA_TYPE_ARRAY_END _C_ARY_E
#define OBJLUA_TYPE_BITFIELD _C_BFLD
#define OBJLUA_TYPE_ID _C_ID
#define OBJLUA_TYPE_CLASS _C_CLASS
#define OBJLUA_TYPE_SELECTOR _C_SEL
#define OBJLUA_TYPE_STRUCT _C_STRUCT_B
#define OBJLUA_TYPE_STRUCT_END _C_STRUCT_E
#define OBJLUA_TYPE_UNION _C_UNION_B
#define OBJLUA_TYPE_UNION_END _C_UNION_E
#define OBJLUA_TYPE_POINTER _C_PTR
#define OBJLUA_TYPE_UNKNOWN _C_UNDEF

#define OBJLUA_PROTOCOL_TYPE_CONST 'r'

#define OBJLUA_PROTOCOL_TYPE_IN 'n'
#define OBJLUA_PROTOCOL_TYPE_INOUT 'N'
#define OBJLUA_PROTOCOL_TYPE_OUT 'o'
#define OBJLUA_PROTOCOL_TYPE_BYCOPY 'O'
#define OBJLUA_PROTOCOL_TYPE_BYREF 'R'
#define OBJLUA_PROTOCOL_TYPE_ONEWAY 'V'

#define BEGIN_STACK_MODIFY(L) int __startStackIndex = lua_gettop((L));

#define END_STACK_MODIFY(L, i) while(lua_gettop((L)) > (__startStackIndex + i)) lua_remove(L, __startStackIndex + 1);


// This struct seem unnessessary
typedef struct _Objlua_selectors {
    SEL selectors[2];
} Objlua_selectors;

// Debug Helpers
void objlua_print_stack(lua_State *L);
void objlua_print_stack_at(lua_State *L, int i);
void objlua_print_table(lua_State *L, int t);

// Convertion Helpers
int objlua_from_objc(lua_State *L, const char *typeDescription, void *buffer);
void objlua_from_objc_instance(lua_State *L, id instance);
void objlua_from_struct(lua_State *L, const char *typeDescription, void *buffer);
    
void *objlua_to_objc(lua_State *L, const char *typeDescription, int stackIndex, int *outsize);

// Misc Helpers
Objlua_selectors objlua_selectors_for_name(const char *methodName);
SEL objlua_selector_for_instance(ObjLua_Instance *objlua_instance, const char *methodName);
void objlua_push_method_name_from_selector(lua_State *L, SEL selector);

const char *objlua_remove_protocol_encodings(const char *type_descriptions);

int objlua_size_of_type_description(const char *full_type_description);
int objlua_simplify_type_description(const char *in, char *out);
