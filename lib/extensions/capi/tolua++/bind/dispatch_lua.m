/*
** Lua binding: dispatch
** Generated automatically by tolua++-1.0.92 on Thu Mar 26 13:55:57 2015.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"
#include "wax_lock.h"

/* Exported function */
TOLUA_API int  tolua_dispatch_open (lua_State* tolua_S);

#include <dispatch/dispatch.h>

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
}

/* function: dispatch_get_main_queue */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_get_main_queue00
static int tolua_dispatch_dispatch_get_main_queue00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,1,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   void* tolua_ret = (void*)  dispatch_get_main_queue();
   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_get_main_queue'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_get_global_queue */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_get_global_queue00
static int tolua_dispatch_dispatch_get_global_queue00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  long identifier = ((long)  tolua_tonumber(tolua_S,1,0));
  unsigned long flags = ((unsigned long)  tolua_tonumber(tolua_S,2,0));
  {
   void* tolua_ret = (void*)  dispatch_get_global_queue(identifier,flags);
   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_get_global_queue'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_queue_create */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_queue_create00
static int tolua_dispatch_dispatch_queue_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* label = ((const char*)  tolua_tostring(tolua_S,1,0));
  void* attr = ((void*)  tolua_touserdata(tolua_S,2,0));
  {
   void* tolua_ret = (void*)  dispatch_queue_create(label,attr);
   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_queue_create'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

///* function: dispatch_get_current_queue */
//#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_get_current_queue00
//static int tolua_dispatch_dispatch_get_current_queue00(lua_State* tolua_S)
//{
//#ifndef TOLUA_RELEASE
// tolua_Error tolua_err;
// if (
//     !tolua_isnoobj(tolua_S,1,&tolua_err)
// )
//  goto tolua_lerror;
// else
//#endif
// {
//  {
//   void* tolua_ret = (void*)  dispatch_get_current_queue();
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
//  }
// }
// return 1;
//#ifndef TOLUA_RELEASE
// tolua_lerror:
// tolua_error(tolua_S,"#ferror in function 'dispatch_get_current_queue'.",&tolua_err);
// return 0;
//#endif
//}
//#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_queue_get_label */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_queue_get_label00
static int tolua_dispatch_dispatch_queue_get_label00(lua_State* tolua_S)
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
  void* queue = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   const char* tolua_ret = (const char*)  dispatch_queue_get_label(queue);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_queue_get_label'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_main */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_main00
static int tolua_dispatch_dispatch_main00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,1,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   dispatch_main();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_main'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_async */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_async00
static int tolua_dispatch_dispatch_async00(lua_State* tolua_S)
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
  void* queue = ((void*)  tolua_touserdata(tolua_S,1,0));
  void* block = ((void*)  tolua_touserdata(tolua_S,2,0));
  {
   dispatch_async(queue,block);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_async'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_sync */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_sync00
static int tolua_dispatch_dispatch_sync00(lua_State* tolua_S)
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
  void* queue = ((void*)  tolua_touserdata(tolua_S,1,0));
  void* block = ((void*)  tolua_touserdata(tolua_S,2,0));
  {
   dispatch_sync(queue,block);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_sync'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_after */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_after00
static int tolua_dispatch_dispatch_after00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long long when = ((unsigned long long)  tolua_tonumber(tolua_S,1,0));
  void* queue = ((void*)  tolua_touserdata(tolua_S,2,0));
  void* block = ((void*)  tolua_touserdata(tolua_S,3,0));
  {
   dispatch_after(when,queue,block);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_after'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_apply */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_apply00
static int tolua_dispatch_dispatch_apply00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  size_t iterations = ((size_t)  tolua_tonumber(tolua_S,1,0));
  void* queue = ((void*)  tolua_touserdata(tolua_S,2,0));
  void* tolua_var_1 = ((void*)  tolua_touserdata(tolua_S,3,0));
  {
   dispatch_apply(iterations,queue,tolua_var_1);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_apply'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_once */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_once00
static int tolua_dispatch_dispatch_once00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  long predicate = ((long)  tolua_tonumber(tolua_S,1,0));
  void* block = ((void*)  tolua_touserdata(tolua_S,2,0));
  {
   dispatch_once(&predicate,block);
   tolua_pushnumber(tolua_S,(lua_Number)predicate);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_once'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_semaphore_create */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_semaphore_create00
static int tolua_dispatch_dispatch_semaphore_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  long value = ((long)  tolua_tonumber(tolua_S,1,0));
  {
   void* tolua_ret = (void*)  dispatch_semaphore_create(value);
   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_semaphore_create'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_semaphore_signal */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_semaphore_signal00
static int tolua_dispatch_dispatch_semaphore_signal00(lua_State* tolua_S)
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
  void* dsema = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   long tolua_ret = (long)  dispatch_semaphore_signal(dsema);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_semaphore_signal'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_semaphore_wait */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_semaphore_wait00
static int tolua_dispatch_dispatch_semaphore_wait00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* dsema = ((void*)  tolua_touserdata(tolua_S,1,0));
  unsigned long long timeout = ((unsigned long long)  tolua_tonumber(tolua_S,2,0));
  {
   long tolua_ret = (long)  dispatch_semaphore_wait(dsema,timeout);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_semaphore_wait'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: dispatch_time */
#ifndef TOLUA_DISABLE_tolua_dispatch_dispatch_time00
static int tolua_dispatch_dispatch_time00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long long when = ((unsigned long long)  tolua_tonumber(tolua_S,1,0));
  long long delta = ((long long)  tolua_tonumber(tolua_S,2,0));
  {
   unsigned long long tolua_ret = (unsigned long long)  dispatch_time(when,delta);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'dispatch_time'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_dispatch_open (lua_State* tolua_S)
{
    [wax_globalLock() lock];
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_constant(tolua_S,"DISPATCH_QUEUE_PRIORITY_HIGH",DISPATCH_QUEUE_PRIORITY_HIGH);
  tolua_constant(tolua_S,"DISPATCH_QUEUE_PRIORITY_DEFAULT",DISPATCH_QUEUE_PRIORITY_DEFAULT);
  tolua_constant(tolua_S,"DISPATCH_QUEUE_PRIORITY_LOW",DISPATCH_QUEUE_PRIORITY_LOW);
  tolua_constant(tolua_S,"DISPATCH_QUEUE_PRIORITY_BACKGROUND",DISPATCH_QUEUE_PRIORITY_BACKGROUND);
  tolua_constant(tolua_S,"DISPATCH_TIME_NOW",DISPATCH_TIME_NOW);
  tolua_constant(tolua_S,"DISPATCH_TIME_FOREVER",DISPATCH_TIME_FOREVER);
  tolua_constant(tolua_S,"NSEC_PER_SEC",NSEC_PER_SEC);
  tolua_function(tolua_S,"dispatch_get_main_queue",tolua_dispatch_dispatch_get_main_queue00);
  tolua_function(tolua_S,"dispatch_get_global_queue",tolua_dispatch_dispatch_get_global_queue00);
  tolua_function(tolua_S,"dispatch_queue_create",tolua_dispatch_dispatch_queue_create00);
//  tolua_function(tolua_S,"dispatch_get_current_queue",tolua_dispatch_dispatch_get_current_queue00);
  tolua_function(tolua_S,"dispatch_queue_get_label",tolua_dispatch_dispatch_queue_get_label00);
  tolua_function(tolua_S,"dispatch_main",tolua_dispatch_dispatch_main00);
  tolua_function(tolua_S,"dispatch_async",tolua_dispatch_dispatch_async00);
  tolua_function(tolua_S,"dispatch_sync",tolua_dispatch_dispatch_sync00);
  tolua_function(tolua_S,"dispatch_after",tolua_dispatch_dispatch_after00);
  tolua_function(tolua_S,"dispatch_apply",tolua_dispatch_dispatch_apply00);
  tolua_function(tolua_S,"dispatch_once",tolua_dispatch_dispatch_once00);
  tolua_function(tolua_S,"dispatch_semaphore_create",tolua_dispatch_dispatch_semaphore_create00);
  tolua_function(tolua_S,"dispatch_semaphore_signal",tolua_dispatch_dispatch_semaphore_signal00);
  tolua_function(tolua_S,"dispatch_semaphore_wait",tolua_dispatch_dispatch_semaphore_wait00);
  tolua_function(tolua_S,"dispatch_time",tolua_dispatch_dispatch_time00);
 tolua_endmodule(tolua_S);
    
    [wax_globalLock() unlock];
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_dispatch (lua_State* tolua_S) {
 return tolua_dispatch_open(tolua_S);
};
#endif

