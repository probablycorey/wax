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

//#define _C_CLASS    '#'
//#define _C_SEL      ':'
//#define _C_UCHR     'C'
//#define _C_SHT      's'
//#define _C_USHT     'S'
//#define _C_UINT     'I'
//#define _C_LNG      'l'
//#define _C_ULNG     'L'
//#define _C_LNG_LNG  'q'
//#define _C_ULNG_LNG 'Q'
//#define _C_FLT      'f'
//#define _C_DBL      'd'
//#define _C_BFLD     'b'
//#define _C_BOOL     'B'
//#define _C_VOID     'v'
//#define _C_UNDEF    '?'
//#define _C_PTR      '^'
//#define _C_CHARPTR  '*'
//#define _C_ATOM     '%'
//#define _C_ARY_B    '['
//#define _C_ARY_E    ']'
//#define _C_UNION_B  '('
//#define _C_UNION_E  ')'
//#define _C_STRUCT_B '{'
//#define _C_STRUCT_E '}'
//#define _C_VECTOR   '!'
//#define _C_CONST    'r'

#define OBJLUA_TYPE_CHAR _C_CHR
#define OBJLUA_TYPE_INT _C_INT
#define OBJLUA_TYPE_SHORT 's'
#define OBJLUA_TYPE_UNSIGNED_CHAR 'C'
#define OBJLUA_TYPE_UNSIGNED_INT 'I'
#define OBJLUA_TYPE_UNSIGNED_SHORT 'S'

#define OBJLUA_TYPE_LONG 'l'
#define OBJLUA_TYPE_LONG_LONG 'q'
#define OBJLUA_TYPE_UNSIGNED_LONG 'L'
#define OBJLUA_TYPE_UNSIGNED_LONG_LONG 'Q'
#define OBJLUA_TYPE_FLOAT 'f'
#define OBJLUA_TYPE_DOUBLE 'd'

#define OBJLUA_TYPE_C99_BOOL 'B'

#define OBJLUA_TYPE_STRING '*'
#define OBJLUA_TYPE_VOID 'v'
#define OBJLUA_TYPE_ARRAY '['
#define OBJLUA_TYPE_ARRAY_END ']'
#define OBJLUA_TYPE_BITFIELD 'b'
#define OBJLUA_TYPE_ID _C_ID
#define OBJLUA_TYPE_CLASS '#'
#define OBJLUA_TYPE_SELECTOR ':'
#define OBJLUA_TYPE_STRUCT '{'
#define OBJLUA_TYPE_STRUCT_END '}'
#define OBJLUA_TYPE_UNION '('
#define OBJLUA_TYPE_UNION_END ')'
#define OBJLUA_TYPE_POINTER '^'
#define OBJLUA_TYPE_UNKNOWN '?'

#define OBJLUA_PROTOCOL_TYPE_CONST 'r'

#define OBJLUA_PROTOCOL_TYPE_IN 'n'

#define OBJLUA_PROTOCOL_TYPE_INOUT 'N'
#define OBJLUA_PROTOCOL_TYPE_OUT 'o'
#define OBJLUA_PROTOCOL_TYPE_BYCOPY 'O'
#define OBJLUA_PROTOCOL_TYPE_BYREF 'R'
#define OBJLUA_PROTOCOL_TYPE_ONEWAY 'V'

#define BEGIN_STACK_MODIFY(L) int __startStackIndex = lua_gettop((L));

#define END_STACK_MODIFY(L, i) while(lua_gettop((L)) > (__startStackIndex + i)) lua_remove(L, __startStackIndex + 1)


// This struct seem unnessessary
typedef struct _Objlua_selectors {
    SEL selectors[2];
} Objlua_selectors;

// Debug Helpers
void objlua_stack_dump(lua_State *L);
void objlua_print_stack_index(lua_State *L, int i);
void objlua_print_table(lua_State *L, int t);

// Convertion Helpers
int objlua_from_objc(lua_State *L, const char *typeDescription, void *buffer);
void objlua_from_objc_instance(lua_State *L, id instance);
void objlua_from_struct(lua_State *L, const char *typeDescription, void *buffer, int size);
    
void *objlua_to_objc(lua_State *L, const char *typeDescription, int stackIndex, int *outsize);

// Misc Helpers
Objlua_selectors objlua_selector_from_method_name(const char *methodName);
void objlua_push_method_name_from_selector(lua_State *L, SEL selector);

const char *objlua_remove_protocol_encodings(const char *type_encodings);

int objlua_size_of_type_encoding(const char *full_type_encoding);
int objlua_simplify_type_encoding(const char *in, char *out);