/*
** Lua binding: pthread
** Generated automatically by tolua++-1.0.92 on Tue Apr 21 20:40:57 2015.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"
#import "wax_lock.h"

/* Exported function */
TOLUA_API int  tolua_pthread_open (lua_State* tolua_S);

#import <pthread/pthread.h>

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
}

/* function: pthread_mutex_init */
#ifndef TOLUA_DISABLE_tolua_pthread_pthread_mutex_init00
static int tolua_pthread_pthread_mutex_init00(lua_State* tolua_S)
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
  void* mutex = ((void*)  tolua_touserdata(tolua_S,1,0));
  void* attr = ((void*)  tolua_touserdata(tolua_S,2,0));
  {
   int tolua_ret = (int)  pthread_mutex_init(mutex,attr);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pthread_mutex_init'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: pthread_mutex_destroy */
#ifndef TOLUA_DISABLE_tolua_pthread_pthread_mutex_destroy00
static int tolua_pthread_pthread_mutex_destroy00(lua_State* tolua_S)
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
  void* mutex = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   int tolua_ret = (int)  pthread_mutex_destroy(mutex);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pthread_mutex_destroy'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: pthread_mutex_lock */
#ifndef TOLUA_DISABLE_tolua_pthread_pthread_mutex_lock00
static int tolua_pthread_pthread_mutex_lock00(lua_State* tolua_S)
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
  void* mutex = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   int tolua_ret = (int)  pthread_mutex_lock(mutex);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pthread_mutex_lock'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: pthread_mutex_trylock */
#ifndef TOLUA_DISABLE_tolua_pthread_pthread_mutex_trylock00
static int tolua_pthread_pthread_mutex_trylock00(lua_State* tolua_S)
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
  void* mutex = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   int tolua_ret = (int)  pthread_mutex_trylock(mutex);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pthread_mutex_trylock'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: pthread_mutex_unlock */
#ifndef TOLUA_DISABLE_tolua_pthread_pthread_mutex_unlock00
static int tolua_pthread_pthread_mutex_unlock00(lua_State* tolua_S)
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
  void* mutex = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   int tolua_ret = (int)  pthread_mutex_unlock(mutex);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pthread_mutex_unlock'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_pthread_open (lua_State* tolua_S)
{
    [wax_globalLock() lock];
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_function(tolua_S,"pthread_mutex_init",tolua_pthread_pthread_mutex_init00);
  tolua_function(tolua_S,"pthread_mutex_destroy",tolua_pthread_pthread_mutex_destroy00);
  tolua_function(tolua_S,"pthread_mutex_lock",tolua_pthread_pthread_mutex_lock00);
  tolua_function(tolua_S,"pthread_mutex_trylock",tolua_pthread_pthread_mutex_trylock00);
  tolua_function(tolua_S,"pthread_mutex_unlock",tolua_pthread_pthread_mutex_unlock00);
 tolua_endmodule(tolua_S);
    [wax_globalLock() unlock];
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_pthread (lua_State* tolua_S) {
 return tolua_pthread_open(tolua_S);
};
#endif

