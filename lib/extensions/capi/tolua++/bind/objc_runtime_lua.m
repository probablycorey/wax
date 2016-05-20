/*
** Lua binding: objc_runtime
** Generated automatically by tolua++-1.0.92 on Wed Sep  9 14:38:16 2015.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"
#import "wax_helpers.h"
#import "wax_capi.h"

/* Exported function */
TOLUA_API int  tolua_objc_runtime_open (lua_State* tolua_S);

#include <objc/message.h>

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
}

/* function: class_getName */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_class_getName00
static int tolua_objc_runtime_class_getName00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* cls = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   const char* tolua_ret = (const char*)  class_getName(cls);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'class_getName'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: class_getSuperclass */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_class_getSuperclass00
static int tolua_objc_runtime_class_getSuperclass00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* cls = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   void* tolua_ret = (void*)  class_getSuperclass(cls);
   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'class_getSuperclass'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

///* function: class_setSuperclass */
//#ifndef TOLUA_DISABLE_tolua_objc_runtime_class_setSuperclass00
//static int tolua_objc_runtime_class_setSuperclass00(lua_State* tolua_S)
//{
//#ifndef TOLUA_RELEASE
// tolua_Error tolua_err;
// if (
//     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
//     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
//     !tolua_isnoobj(tolua_S,3,&tolua_err)
// )
//  goto tolua_lerror;
// else
//#endif
// {
//  void* cls = ((void*)  tolua_touserdata(tolua_S,1,0));
//  void* newSuper = ((void*)  tolua_touserdata(tolua_S,2,0));
//  {
//   void* tolua_ret = (void*)  class_setSuperclass(cls,newSuper);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
//  }
// }
// return 1;
//#ifndef TOLUA_RELEASE
// tolua_lerror:
// tolua_error(tolua_S,"#ferror in function 'class_setSuperclass'.",&tolua_err);
// return 0;
//#endif
//}
//#endif //#ifndef TOLUA_DISABLE

/* function: class_isMetaClass */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_class_isMetaClass00
static int tolua_objc_runtime_class_isMetaClass00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* cls = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   bool tolua_ret = (bool)  class_isMetaClass(cls);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'class_isMetaClass'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: class_getInstanceSize */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_class_getInstanceSize00
static int tolua_objc_runtime_class_getInstanceSize00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* cls = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   long tolua_ret = (long)  class_getInstanceSize(cls);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'class_getInstanceSize'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: class_getInstanceVariable */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_class_getInstanceVariable00
static int tolua_objc_runtime_class_getInstanceVariable00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* cls = ((void*)  tolua_touserdata(tolua_S,1,0));
  const char* name = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   void* tolua_ret = (void*)  class_getInstanceVariable(cls,name);
   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'class_getInstanceVariable'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: class_getClassVariable */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_class_getClassVariable00
static int tolua_objc_runtime_class_getClassVariable00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* cls = ((void*)  tolua_touserdata(tolua_S,1,0));
  const char* name = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   void* tolua_ret = (void*)  class_getClassVariable(cls,name);
   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'class_getClassVariable'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: object_getClass */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_object_getClass00
static int tolua_objc_runtime_object_getClass00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* obj = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   void* tolua_ret = (void*)  object_getClass(obj);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_fromInstance(tolua_S, tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'object_getClass'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: objc_getClass */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_objc_getClass00
static int tolua_objc_runtime_objc_getClass00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* name = ((const char*)  tolua_tostring(tolua_S,1,0));
  {
   void* tolua_ret = (void*)  objc_getClass(name);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_fromInstance(tolua_S, tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'objc_getClass'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: objc_setAssociatedObject */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_objc_setAssociatedObject00
static int tolua_objc_runtime_objc_setAssociatedObject00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  void* object = ((void*)  tolua_touserdata(tolua_S,1,0));
     id object = wax_objectFromLuaState(tolua_S, 1);
  void* key = ((void*)  tolua_touserdata(tolua_S,2,0));
//  void* value = ((void*)  tolua_touserdata(tolua_S,3,0));
     id value = wax_objectFromLuaState(tolua_S, 3);
  long policy = (( long)  tolua_tonumber(tolua_S,4,0));
  {
   objc_setAssociatedObject(object,key,value,policy);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'objc_setAssociatedObject'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: objc_getAssociatedObject */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_objc_getAssociatedObject00
static int tolua_objc_runtime_objc_getAssociatedObject00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* object = ((void*)  tolua_touserdata(tolua_S,1,0));
  const void* key = ((const void*)  tolua_touserdata(tolua_S,2,0));
  {
   void* tolua_ret = (void*)  objc_getAssociatedObject(object,key);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_fromInstance(tolua_S, tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'objc_getAssociatedObject'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: objc_removeAssociatedObjects */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_objc_removeAssociatedObjects00
static int tolua_objc_runtime_objc_removeAssociatedObjects00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* object = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   objc_removeAssociatedObjects(object);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'objc_removeAssociatedObjects'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: property_getName */
#ifndef TOLUA_DISABLE_tolua_objc_runtime_property_getName00
static int tolua_objc_runtime_property_getName00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* property = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   const char* tolua_ret = (const char*)  property_getName(property);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'property_getName'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_objc_runtime_open (lua_State* tolua_S)
{
    [wax_globalLock() lock];
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_constant(tolua_S,"OBJC_ASSOCIATION_ASSIGN",OBJC_ASSOCIATION_ASSIGN);
  tolua_constant(tolua_S,"OBJC_ASSOCIATION_RETAIN_NONATOMIC",OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  tolua_constant(tolua_S,"OBJC_ASSOCIATION_COPY_NONATOMIC",OBJC_ASSOCIATION_COPY_NONATOMIC);
  tolua_constant(tolua_S,"OBJC_ASSOCIATION_RETAIN",OBJC_ASSOCIATION_RETAIN);
  tolua_constant(tolua_S,"OBJC_ASSOCIATION_COPY",OBJC_ASSOCIATION_COPY);
  tolua_function(tolua_S,"class_getName",tolua_objc_runtime_class_getName00);
  tolua_function(tolua_S,"class_getSuperclass",tolua_objc_runtime_class_getSuperclass00);
//  tolua_function(tolua_S,"class_setSuperclass",tolua_objc_runtime_class_setSuperclass00);
  tolua_function(tolua_S,"class_isMetaClass",tolua_objc_runtime_class_isMetaClass00);
  tolua_function(tolua_S,"class_getInstanceSize",tolua_objc_runtime_class_getInstanceSize00);
  tolua_function(tolua_S,"class_getInstanceVariable",tolua_objc_runtime_class_getInstanceVariable00);
  tolua_function(tolua_S,"class_getClassVariable",tolua_objc_runtime_class_getClassVariable00);
  tolua_function(tolua_S,"object_getClass",tolua_objc_runtime_object_getClass00);
  tolua_function(tolua_S,"objc_getClass",tolua_objc_runtime_objc_getClass00);
  tolua_function(tolua_S,"objc_setAssociatedObject",tolua_objc_runtime_objc_setAssociatedObject00);
  tolua_function(tolua_S,"objc_getAssociatedObject",tolua_objc_runtime_objc_getAssociatedObject00);
  tolua_function(tolua_S,"objc_removeAssociatedObjects",tolua_objc_runtime_objc_removeAssociatedObjects00);
  tolua_function(tolua_S,"property_getName",tolua_objc_runtime_property_getName00);
 tolua_endmodule(tolua_S);
    
    [wax_globalLock() unlock];
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_objc_runtime (lua_State* tolua_S) {
 return tolua_objc_runtime_open(tolua_S);
};
#endif

