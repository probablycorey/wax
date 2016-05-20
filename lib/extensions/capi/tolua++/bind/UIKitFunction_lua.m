/*
** Lua binding: UIKitFunction
** Generated automatically by tolua++-1.0.92 on Tue Apr 21 17:28:31 2015.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_UIKitFunction_open (lua_State* tolua_S);

#import "wax_struct.h"
#import "wax_instance.h"
#import "wax_helpers.h"
#import "wax_capi.h"
#import <UIKit/UIKit.h>
/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
}

/* function: UIImageJPEGRepresentation */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIImageJPEGRepresentation00
static int tolua_UIKitFunction_UIImageJPEGRepresentation00(lua_State* tolua_S)
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
  void* image = ((void*)  tolua_touserdata(tolua_S,1,0));
  double compressionQuality = ((double)  tolua_tonumber(tolua_S,2,0));
  {
   void* tolua_ret = (void*)  UIImageJPEGRepresentation(image,compressionQuality);
      wax_fromObjc(tolua_S, "@", &tolua_ret);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIImageJPEGRepresentation'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIImagePNGRepresentation */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIImagePNGRepresentation00
static int tolua_UIKitFunction_UIImagePNGRepresentation00(lua_State* tolua_S)
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
  void* image = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   void* tolua_ret = (void*)  UIImagePNGRepresentation(image);
        wax_fromObjc(tolua_S, "@", &tolua_ret);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIImagePNGRepresentation'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIImageWriteToSavedPhotosAlbum */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIImageWriteToSavedPhotosAlbum00
static int tolua_UIKitFunction_UIImageWriteToSavedPhotosAlbum00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* image = ((void*)  tolua_touserdata(tolua_S,1,0));
  void* completionTarget = ((void*)  tolua_touserdata(tolua_S,2,0));
  char* completionSelector = ((char*)  tolua_tostring(tolua_S,3,0));
  void* contextInfo = ((void*)  tolua_touserdata(tolua_S,4,0));
  {
   UIImageWriteToSavedPhotosAlbum(image,completionTarget,sel_getUid(completionSelector),contextInfo);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIImageWriteToSavedPhotosAlbum'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UISaveVideoAtPathToSavedPhotosAlbum */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UISaveVideoAtPathToSavedPhotosAlbum00
static int tolua_UIKitFunction_UISaveVideoAtPathToSavedPhotosAlbum00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  void* videoPath = ((void*)  tolua_touserdata(tolua_S,1,0));
     id *instancePointer = wax_copyToObjc(tolua_S, "@", 1, nil);
     id instance = *(id *)instancePointer;
     free(instancePointer);
     
     NSString *videoPath = instance;

  void* completionTarget = ((void*)  tolua_touserdata(tolua_S,2,0));
  char* completionSelector = ((char*)  tolua_tostring(tolua_S,3,0));
  void* contextInfo = ((void*)  tolua_touserdata(tolua_S,4,0));
  {
   UISaveVideoAtPathToSavedPhotosAlbum(videoPath,completionTarget,sel_getUid(completionSelector),contextInfo);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UISaveVideoAtPathToSavedPhotosAlbum'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIVideoAtPathIsCompatibleWithSavedPhotosAlbum */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIVideoAtPathIsCompatibleWithSavedPhotosAlbum00
static int tolua_UIKitFunction_UIVideoAtPathIsCompatibleWithSavedPhotosAlbum00(lua_State* tolua_S)
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
//  void* videoPath = ((void*)  tolua_touserdata(tolua_S,1,0));
     id *instancePointer = wax_copyToObjc(tolua_S, "@", 1, nil);
     id instance = *(id *)instancePointer;
     free(instancePointer);
     
     NSString *videoPath = instance;

  {
   bool tolua_ret = (bool)  UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIVideoAtPathIsCompatibleWithSavedPhotosAlbum'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsGetCurrentContext */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsGetCurrentContext00
static int tolua_UIKitFunction_UIGraphicsGetCurrentContext00(lua_State* tolua_S)
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
   void* tolua_ret = (void*)  UIGraphicsGetCurrentContext();
   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsGetCurrentContext'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsPushContext */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsPushContext00
static int tolua_UIKitFunction_UIGraphicsPushContext00(lua_State* tolua_S)
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
  void* context = ((void*)  tolua_touserdata(tolua_S,1,0));
  {
   UIGraphicsPushContext(context);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsPushContext'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsPopContext */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsPopContext00
static int tolua_UIKitFunction_UIGraphicsPopContext00(lua_State* tolua_S)
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
   UIGraphicsPopContext();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsPopContext'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsBeginImageContext */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsBeginImageContext00
static int tolua_UIKitFunction_UIGraphicsBeginImageContext00(lua_State* tolua_S)
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
  CGSize size = *((CGSize*)tolua_touserdata(tolua_S, 1, 0));
  {
   UIGraphicsBeginImageContext(size);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsBeginImageContext'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsBeginImageContextWithOptions */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsBeginImageContextWithOptions00
static int tolua_UIKitFunction_UIGraphicsBeginImageContextWithOptions00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CGSize size = *((CGSize*)tolua_touserdata(tolua_S, 1, 0));
  bool opaque = ((bool)  tolua_toboolean(tolua_S,2,0));
  double scale = ((double)  tolua_tonumber(tolua_S,3,0));
  {
   UIGraphicsBeginImageContextWithOptions(size,opaque,scale);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsBeginImageContextWithOptions'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsGetImageFromCurrentImageContext */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsGetImageFromCurrentImageContext00
static int tolua_UIKitFunction_UIGraphicsGetImageFromCurrentImageContext00(lua_State* tolua_S)
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
   void* tolua_ret = (void*)  UIGraphicsGetImageFromCurrentImageContext();
      wax_fromObjc(tolua_S, "@", &tolua_ret);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsGetImageFromCurrentImageContext'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsEndImageContext */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsEndImageContext00
static int tolua_UIKitFunction_UIGraphicsEndImageContext00(lua_State* tolua_S)
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
   UIGraphicsEndImageContext();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsEndImageContext'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIRectClip */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIRectClip00
static int tolua_UIKitFunction_UIRectClip00(lua_State* tolua_S)
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
//  void* rect = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 1, 0));
  {
   UIRectClip(rect);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIRectClip'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIRectFill */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIRectFill00
static int tolua_UIKitFunction_UIRectFill00(lua_State* tolua_S)
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
//  void* rect = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 1, 0));
  {
   UIRectFill(rect);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIRectFill'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIRectFillUsingBlendMode */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIRectFillUsingBlendMode00
static int tolua_UIKitFunction_UIRectFillUsingBlendMode00(lua_State* tolua_S)
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
//  void* rect = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 1, 0));
  CGBlendMode blendMode = ((CGBlendMode)  tolua_tonumber(tolua_S,2,0));
  {
   UIRectFillUsingBlendMode(rect,blendMode);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIRectFillUsingBlendMode'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIRectFrame */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIRectFrame00
static int tolua_UIKitFunction_UIRectFrame00(lua_State* tolua_S)
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
//  void* rect = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 1, 0));
  {
   UIRectFrame(rect);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIRectFrame'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIRectFrameUsingBlendMode */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIRectFrameUsingBlendMode00
static int tolua_UIKitFunction_UIRectFrameUsingBlendMode00(lua_State* tolua_S)
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
//  void* rect = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 1, 0));
  CGBlendMode blendMode = ((CGBlendMode)  tolua_tonumber(tolua_S,2,0));
  {
   UIRectFrameUsingBlendMode(rect,blendMode);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIRectFrameUsingBlendMode'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsBeginPDFContextToData */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsBeginPDFContextToData00
static int tolua_UIKitFunction_UIGraphicsBeginPDFContextToData00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  void* data = ((void*)  tolua_touserdata(tolua_S,1,0));
     id *instancePointer = wax_copyToObjc(tolua_S, "@", 1, nil);
     id instance = *(id *)instancePointer;
     free(instancePointer);
     
      id data = instance;

//  void* bounds = ((void*)  tolua_touserdata(tolua_S,2,0));
     CGRect bounds = *((CGRect*)tolua_touserdata(tolua_S, 2, 0));
  void* documentInfo = ((void*)  tolua_touserdata(tolua_S,3,0));
  {
   UIGraphicsBeginPDFContextToData(data,bounds,documentInfo);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsBeginPDFContextToData'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsBeginPDFContextToFile */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsBeginPDFContextToFile00
static int tolua_UIKitFunction_UIGraphicsBeginPDFContextToFile00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isuserdata(tolua_S,1,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  void* path = ((void*)  tolua_touserdata(tolua_S,1,0));
     id *instancePointer = wax_copyToObjc(tolua_S, "@", 1, nil);
     id instance = *(id *)instancePointer;
     free(instancePointer);
     id path = instance;
//  void* bounds = ((void*)  tolua_touserdata(tolua_S,2,0));
     CGRect bounds = *((CGRect*)tolua_touserdata(tolua_S, 2, 0));
  void* documentInfo = ((void*)  tolua_touserdata(tolua_S,3,0));
  {
   bool tolua_ret = (bool)  UIGraphicsBeginPDFContextToFile(path,bounds,documentInfo);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsBeginPDFContextToFile'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsEndPDFContext */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsEndPDFContext00
static int tolua_UIKitFunction_UIGraphicsEndPDFContext00(lua_State* tolua_S)
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
   UIGraphicsEndPDFContext();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsEndPDFContext'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsBeginPDFPage */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsBeginPDFPage00
static int tolua_UIKitFunction_UIGraphicsBeginPDFPage00(lua_State* tolua_S)
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
   UIGraphicsBeginPDFPage();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsBeginPDFPage'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsBeginPDFPageWithInfo */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsBeginPDFPageWithInfo00
static int tolua_UIKitFunction_UIGraphicsBeginPDFPageWithInfo00(lua_State* tolua_S)
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
//  void* bounds = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGRect bounds = *((CGRect*)tolua_touserdata(tolua_S, 1, 0));
//  void* pageInfo = ((void*)  tolua_touserdata(tolua_S,2,0));
     id *instancePointer = wax_copyToObjc(tolua_S, "@", 1, nil);
     id instance = *(id *)instancePointer;
     free(instancePointer);
     id pageInfo = instance;
  {
   UIGraphicsBeginPDFPageWithInfo(bounds,pageInfo);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsBeginPDFPageWithInfo'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsGetPDFContextBounds */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsGetPDFContextBounds00
static int tolua_UIKitFunction_UIGraphicsGetPDFContextBounds00(lua_State* tolua_S)
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
   CGRect tolua_ret =  UIGraphicsGetPDFContextBounds();
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_struct_create(tolua_S, @encode(CGRect), &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsGetPDFContextBounds'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsAddPDFContextDestinationAtPoint */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsAddPDFContextDestinationAtPoint00
static int tolua_UIKitFunction_UIGraphicsAddPDFContextDestinationAtPoint00(lua_State* tolua_S)
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
//  void* name = ((void*)  tolua_touserdata(tolua_S,1,0));
     id *instancePointer = wax_copyToObjc(tolua_S, "@", 1, nil);
     id instance = *(id *)instancePointer;
     free(instancePointer);
     id name = instance;
     
//  void* point = ((void*)  tolua_touserdata(tolua_S,2,0));
    CGPoint point = *((CGPoint*)tolua_touserdata(tolua_S, 2, 0));
     
  {
   UIGraphicsAddPDFContextDestinationAtPoint(name,point);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsAddPDFContextDestinationAtPoint'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsSetPDFContextDestinationForRect */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsSetPDFContextDestinationForRect00
static int tolua_UIKitFunction_UIGraphicsSetPDFContextDestinationForRect00(lua_State* tolua_S)
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
//  void* name = ((void*)  tolua_touserdata(tolua_S,1,0));
     id *instancePointer = wax_copyToObjc(tolua_S, "@", 1, nil);
     id instance = *(id *)instancePointer;
     free(instancePointer);
     id name = instance;
//  void* rect = ((void*)  tolua_touserdata(tolua_S,2,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 2, 0));
  {
   UIGraphicsSetPDFContextDestinationForRect(name,rect);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsSetPDFContextDestinationForRect'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGraphicsSetPDFContextURLForRect */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGraphicsSetPDFContextURLForRect00
static int tolua_UIKitFunction_UIGraphicsSetPDFContextURLForRect00(lua_State* tolua_S)
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
//  void* url = ((void*)  tolua_touserdata(tolua_S,1,0));
     id url = wax_objectFromLuaState(tolua_S, 1);
//  void* rect = ((void*)  tolua_touserdata(tolua_S,2,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 2, 0));
  {
   UIGraphicsSetPDFContextURLForRect(url,rect);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGraphicsSetPDFContextURLForRect'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: CGAffineTransformFromString */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_CGAffineTransformFromString00
static int tolua_UIKitFunction_CGAffineTransformFromString00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  _userdata string tolua_var_1 = ((_userdata string)  tolua_tocppstring(tolua_S,1,0));
     id tolua_var_1 = wax_objectFromLuaState(tolua_S, 1);
  {
   CGAffineTransform tolua_ret =  CGAffineTransformFromString(tolua_var_1);
      wax_struct_create(tolua_S, @encode(CGPoint), &tolua_ret);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'CGAffineTransformFromString'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: CGPointFromString */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_CGPointFromString00
static int tolua_UIKitFunction_CGPointFromString00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  _userdata string tolua_var_2 = ((_userdata string)  tolua_tocppstring(tolua_S,1,0));
     id tolua_var_2 = wax_objectFromLuaState(tolua_S, 1);
  {
   CGPoint tolua_ret =  CGPointFromString(tolua_var_2);
      wax_struct_create(tolua_S, @encode(CGPoint), &tolua_ret);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'CGPointFromString'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: CGRectFromString */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_CGRectFromString00
static int tolua_UIKitFunction_CGRectFromString00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  _userdata string tolua_var_3 = ((_userdata string)  tolua_tocppstring(tolua_S,1,0));
     id tolua_var_3 = wax_objectFromLuaState(tolua_S, 1);
  {
   CGRect tolua_ret =  CGRectFromString(tolua_var_3);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_struct_create(tolua_S, @encode(CGRect), &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'CGRectFromString'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: CGSizeFromString */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_CGSizeFromString00
static int tolua_UIKitFunction_CGSizeFromString00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  _userdata string tolua_var_4 = ((_userdata string)  tolua_tocppstring(tolua_S,1,0));
     id tolua_var_4 = wax_objectFromLuaState(tolua_S, 1);
  {
   CGSize tolua_ret =  CGSizeFromString(tolua_var_4);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_struct_create(tolua_S, @encode(CGSize), &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'CGSizeFromString'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: NSStringFromCGAffineTransform */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_NSStringFromCGAffineTransform00
static int tolua_UIKitFunction_NSStringFromCGAffineTransform00(lua_State* tolua_S)
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
//  void* transform = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGAffineTransform transform = *((CGAffineTransform*)tolua_touserdata(tolua_S, 1, 0));
  {
   void* tolua_ret = (void*)  NSStringFromCGAffineTransform(transform);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_fromObjc(tolua_S, "@", &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'NSStringFromCGAffineTransform'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: NSStringFromCGPoint */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_NSStringFromCGPoint00
static int tolua_UIKitFunction_NSStringFromCGPoint00(lua_State* tolua_S)
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
//  void* point = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGPoint point = *((CGPoint*)tolua_touserdata(tolua_S, 1, 0));
  {
   void* tolua_ret = (void*)  NSStringFromCGPoint(point);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
    wax_fromObjc(tolua_S, "@", &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'NSStringFromCGPoint'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: NSStringFromCGRect */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_NSStringFromCGRect00
static int tolua_UIKitFunction_NSStringFromCGRect00(lua_State* tolua_S)
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
//  void* rect = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 1, 0));
  {
   void* tolua_ret = (void*)  NSStringFromCGRect(rect);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_fromObjc(tolua_S, "@", &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'NSStringFromCGRect'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: NSStringFromCGSize */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_NSStringFromCGSize00
static int tolua_UIKitFunction_NSStringFromCGSize00(lua_State* tolua_S)
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
//  void* size = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGSize size = *((CGSize*)tolua_touserdata(tolua_S, 1, 0));
  {
   void* tolua_ret = (void*)  NSStringFromCGSize(size);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_fromObjc(tolua_S, "@", &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'NSStringFromCGSize'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: NSStringFromUIEdgeInsets */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_NSStringFromUIEdgeInsets00
static int tolua_UIKitFunction_NSStringFromUIEdgeInsets00(lua_State* tolua_S)
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
//  void* insets = ((void*)  tolua_touserdata(tolua_S,1,0));
     UIEdgeInsets insets = *((UIEdgeInsets*)tolua_touserdata(tolua_S, 1, 0));
  {
   void* tolua_ret = (void*)  NSStringFromUIEdgeInsets(insets);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_fromObjc(tolua_S, "@", &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'NSStringFromUIEdgeInsets'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: NSStringFromUIOffset */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_NSStringFromUIOffset00
static int tolua_UIKitFunction_NSStringFromUIOffset00(lua_State* tolua_S)
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
//  void* offset = ((void*)  tolua_touserdata(tolua_S,1,0));
     UIOffset offset = *((UIOffset*)tolua_touserdata(tolua_S, 1, 0));
  {
   void* tolua_ret = (void*)  NSStringFromUIOffset(offset);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_fromObjc(tolua_S, "@", &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'NSStringFromUIOffset'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIEdgeInsetsFromString */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIEdgeInsetsFromString00
static int tolua_UIKitFunction_UIEdgeInsetsFromString00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  _userdata string tolua_var_5 = ((_userdata string)  tolua_tocppstring(tolua_S,1,0));
     id tolua_var_5 = wax_objectFromLuaState(tolua_S, 1);
  {
   UIEdgeInsets tolua_ret =  UIEdgeInsetsFromString(tolua_var_5);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_struct_create(tolua_S, @encode(UIEdgeInsets), &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIEdgeInsetsFromString'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIOffsetFromString */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIOffsetFromString00
static int tolua_UIKitFunction_UIOffsetFromString00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
//  _userdata string tolua_var_6 = ((_userdata string)  tolua_tocppstring(tolua_S,1,0));
     id tolua_var_6 = wax_objectFromLuaState(tolua_S, 1);
  {
   UIOffset tolua_ret =  UIOffsetFromString(tolua_var_6);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_struct_create(tolua_S, @encode(UIOffset), &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIOffsetFromString'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE


/* function: UIEdgeInsetsEqualToEdgeInsets */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIEdgeInsetsEqualToEdgeInsets00
static int tolua_UIKitFunction_UIEdgeInsetsEqualToEdgeInsets00(lua_State* tolua_S)
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
//  void* insets1 = ((void*)  tolua_touserdata(tolua_S,1,0));
     UIEdgeInsets insets1 = *((UIEdgeInsets*)tolua_touserdata(tolua_S, 1, 0));
//  void* insets2 = ((void*)  tolua_touserdata(tolua_S,2,0));
     UIEdgeInsets insets2 = *((UIEdgeInsets*)tolua_touserdata(tolua_S, 2, 0));
  {
   bool tolua_ret = (bool)  UIEdgeInsetsEqualToEdgeInsets(insets1,insets2);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIEdgeInsetsEqualToEdgeInsets'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIEdgeInsetsInsetRect */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIEdgeInsetsInsetRect00
static int tolua_UIKitFunction_UIEdgeInsetsInsetRect00(lua_State* tolua_S)
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
//  void* rect = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 1, 0));
//  void* insets = ((void*)  tolua_touserdata(tolua_S,2,0));
     UIEdgeInsets insets = *((UIEdgeInsets*)tolua_touserdata(tolua_S, 2, 0));
  {
   CGRect tolua_ret =  UIEdgeInsetsInsetRect(rect,insets);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      wax_struct_create(tolua_S, @encode(CGRect), &tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIEdgeInsetsInsetRect'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIOffsetEqualToOffset */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIOffsetEqualToOffset00
static int tolua_UIKitFunction_UIOffsetEqualToOffset00(lua_State* tolua_S)
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
//  void* offset1 = ((void*)  tolua_touserdata(tolua_S,1,0));
     UIOffset offset1 = *((UIOffset*)tolua_touserdata(tolua_S, 1, 0));
//  void* offset2 = ((void*)  tolua_touserdata(tolua_S,2,0));
     UIOffset offset2 = *((UIOffset*)tolua_touserdata(tolua_S, 2, 0));
  {
   bool tolua_ret = (bool)  UIOffsetEqualToOffset(offset1,offset2);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIOffsetEqualToOffset'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityPostNotification */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityPostNotification00
static int tolua_UIKitFunction_UIAccessibilityPostNotification00(lua_State* tolua_S)
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
  UIAccessibilityNotifications notification = ((UIAccessibilityNotifications)  tolua_tonumber(tolua_S,1,0));
  void* argument = ((void*)  tolua_touserdata(tolua_S,2,0));
  {
   UIAccessibilityPostNotification(notification,argument);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityPostNotification'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityIsVoiceOverRunning */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityIsVoiceOverRunning00
static int tolua_UIKitFunction_UIAccessibilityIsVoiceOverRunning00(lua_State* tolua_S)
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
   bool tolua_ret = (bool)  UIAccessibilityIsVoiceOverRunning();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityIsVoiceOverRunning'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityIsClosedCaptioningEnabled */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityIsClosedCaptioningEnabled00
static int tolua_UIKitFunction_UIAccessibilityIsClosedCaptioningEnabled00(lua_State* tolua_S)
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
   bool tolua_ret = (bool)  UIAccessibilityIsClosedCaptioningEnabled();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityIsClosedCaptioningEnabled'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityRequestGuidedAccessSession */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityRequestGuidedAccessSession00
static int tolua_UIKitFunction_UIAccessibilityRequestGuidedAccessSession00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isboolean(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  bool enable = ((bool)  tolua_toboolean(tolua_S,1,0));
//  void *tolua_var_7 = tolua_tousertype(tolua_S,2,0));
     id tolua_var_7 = wax_objectFromLuaState(tolua_S, 2);
  {
   UIAccessibilityRequestGuidedAccessSession(enable,tolua_var_7);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityRequestGuidedAccessSession'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityIsGuidedAccessEnabled */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityIsGuidedAccessEnabled00
static int tolua_UIKitFunction_UIAccessibilityIsGuidedAccessEnabled00(lua_State* tolua_S)
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
   bool tolua_ret = (bool)  UIAccessibilityIsGuidedAccessEnabled();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityIsGuidedAccessEnabled'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityIsInvertColorsEnabled */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityIsInvertColorsEnabled00
static int tolua_UIKitFunction_UIAccessibilityIsInvertColorsEnabled00(lua_State* tolua_S)
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
   bool tolua_ret = (bool)  UIAccessibilityIsInvertColorsEnabled();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityIsInvertColorsEnabled'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityIsMonoAudioEnabled */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityIsMonoAudioEnabled00
static int tolua_UIKitFunction_UIAccessibilityIsMonoAudioEnabled00(lua_State* tolua_S)
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
   bool tolua_ret = (bool)  UIAccessibilityIsMonoAudioEnabled();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityIsMonoAudioEnabled'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityZoomFocusChanged */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityZoomFocusChanged00
static int tolua_UIKitFunction_UIAccessibilityZoomFocusChanged00(lua_State* tolua_S)
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
  long type = ((long)  tolua_tonumber(tolua_S,1,0));
//  void* frame = ((void*)  tolua_touserdata(tolua_S,2,0));
     CGRect frame = *((CGRect*)tolua_touserdata(tolua_S, 2, 0));
//  void* view = ((void*)  tolua_touserdata(tolua_S,3,0));
     id view = wax_objectFromLuaState(tolua_S, 3);
  {
   UIAccessibilityZoomFocusChanged(type,frame,view);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityZoomFocusChanged'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityRegisterGestureConflictWithZoom */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityRegisterGestureConflictWithZoom00
static int tolua_UIKitFunction_UIAccessibilityRegisterGestureConflictWithZoom00(lua_State* tolua_S)
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
   UIAccessibilityRegisterGestureConflictWithZoom();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityRegisterGestureConflictWithZoom'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityConvertFrameToScreenCoordinates */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityConvertFrameToScreenCoordinates00
static int tolua_UIKitFunction_UIAccessibilityConvertFrameToScreenCoordinates00(lua_State* tolua_S)
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
//  void* rect = ((void*)  tolua_touserdata(tolua_S,1,0));
     CGRect rect = *((CGRect*)tolua_touserdata(tolua_S, 1, 0));
//  void* view = ((void*)  tolua_touserdata(tolua_S,2,0));
     id view = wax_objectFromLuaState(tolua_S, 2);
  {
   CGRect tolua_ret =   UIAccessibilityConvertFrameToScreenCoordinates(rect,view);
      wax_struct_create(tolua_S, @encode(CGRect), &tolua_ret);
//   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
      
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityConvertFrameToScreenCoordinates'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIAccessibilityConvertPathToScreenCoordinates */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIAccessibilityConvertPathToScreenCoordinates00
static int tolua_UIKitFunction_UIAccessibilityConvertPathToScreenCoordinates00(lua_State* tolua_S)
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
  void* path = ((void*)  tolua_touserdata(tolua_S,1,0));
  void* view = ((void*)  tolua_touserdata(tolua_S,2,0));
  {
   void* tolua_ret = (void*)  UIAccessibilityConvertPathToScreenCoordinates(path,view);
   tolua_pushuserdata(tolua_S,(void*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIAccessibilityConvertPathToScreenCoordinates'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: NSTextAlignmentToCTTextAlignment */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_NSTextAlignmentToCTTextAlignment00
static int tolua_UIKitFunction_NSTextAlignmentToCTTextAlignment00(lua_State* tolua_S)
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
  long nsTextAlignment = ((long)  tolua_tonumber(tolua_S,1,0));
  {
   long tolua_ret = (long)  NSTextAlignmentToCTTextAlignment(nsTextAlignment);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'NSTextAlignmentToCTTextAlignment'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: NSTextAlignmentFromCTTextAlignment */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_NSTextAlignmentFromCTTextAlignment00
static int tolua_UIKitFunction_NSTextAlignmentFromCTTextAlignment00(lua_State* tolua_S)
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
  long ctTextAlignment = ((long)  tolua_tonumber(tolua_S,1,0));
  {
   long tolua_ret = (long)  NSTextAlignmentFromCTTextAlignment(ctTextAlignment);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'NSTextAlignmentFromCTTextAlignment'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UIGuidedAccessRestrictionStateForIdentifier */
#ifndef TOLUA_DISABLE_tolua_UIKitFunction_UIGuidedAccessRestrictionStateForIdentifier00
static int tolua_UIKitFunction_UIGuidedAccessRestrictionStateForIdentifier00(lua_State* tolua_S)
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
//  void* restrictionIdentifier = ((void*)  tolua_touserdata(tolua_S,1,0));
     id restrictionIdentifier = wax_objectFromLuaState(tolua_S, 1);
  {
   long tolua_ret = (long)  UIGuidedAccessRestrictionStateForIdentifier(restrictionIdentifier);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UIGuidedAccessRestrictionStateForIdentifier'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_UIKitFunction_open (lua_State* tolua_S)
{
    [wax_globalLock() lock];
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_function(tolua_S,"UIImageJPEGRepresentation",tolua_UIKitFunction_UIImageJPEGRepresentation00);
  tolua_function(tolua_S,"UIImagePNGRepresentation",tolua_UIKitFunction_UIImagePNGRepresentation00);
  tolua_function(tolua_S,"UIImageWriteToSavedPhotosAlbum",tolua_UIKitFunction_UIImageWriteToSavedPhotosAlbum00);
  tolua_function(tolua_S,"UISaveVideoAtPathToSavedPhotosAlbum",tolua_UIKitFunction_UISaveVideoAtPathToSavedPhotosAlbum00);
  tolua_function(tolua_S,"UIVideoAtPathIsCompatibleWithSavedPhotosAlbum",tolua_UIKitFunction_UIVideoAtPathIsCompatibleWithSavedPhotosAlbum00);
  tolua_function(tolua_S,"UIGraphicsGetCurrentContext",tolua_UIKitFunction_UIGraphicsGetCurrentContext00);
  tolua_function(tolua_S,"UIGraphicsPushContext",tolua_UIKitFunction_UIGraphicsPushContext00);
  tolua_function(tolua_S,"UIGraphicsPopContext",tolua_UIKitFunction_UIGraphicsPopContext00);
  tolua_function(tolua_S,"UIGraphicsBeginImageContext",tolua_UIKitFunction_UIGraphicsBeginImageContext00);
  tolua_function(tolua_S,"UIGraphicsBeginImageContextWithOptions",tolua_UIKitFunction_UIGraphicsBeginImageContextWithOptions00);
  tolua_function(tolua_S,"UIGraphicsGetImageFromCurrentImageContext",tolua_UIKitFunction_UIGraphicsGetImageFromCurrentImageContext00);
  tolua_function(tolua_S,"UIGraphicsEndImageContext",tolua_UIKitFunction_UIGraphicsEndImageContext00);
  tolua_function(tolua_S,"UIRectClip",tolua_UIKitFunction_UIRectClip00);
  tolua_function(tolua_S,"UIRectFill",tolua_UIKitFunction_UIRectFill00);
  tolua_function(tolua_S,"UIRectFillUsingBlendMode",tolua_UIKitFunction_UIRectFillUsingBlendMode00);
  tolua_function(tolua_S,"UIRectFrame",tolua_UIKitFunction_UIRectFrame00);
  tolua_function(tolua_S,"UIRectFrameUsingBlendMode",tolua_UIKitFunction_UIRectFrameUsingBlendMode00);
  tolua_function(tolua_S,"UIGraphicsBeginPDFContextToData",tolua_UIKitFunction_UIGraphicsBeginPDFContextToData00);
  tolua_function(tolua_S,"UIGraphicsBeginPDFContextToFile",tolua_UIKitFunction_UIGraphicsBeginPDFContextToFile00);
  tolua_function(tolua_S,"UIGraphicsEndPDFContext",tolua_UIKitFunction_UIGraphicsEndPDFContext00);
  tolua_function(tolua_S,"UIGraphicsBeginPDFPage",tolua_UIKitFunction_UIGraphicsBeginPDFPage00);
  tolua_function(tolua_S,"UIGraphicsBeginPDFPageWithInfo",tolua_UIKitFunction_UIGraphicsBeginPDFPageWithInfo00);
  tolua_function(tolua_S,"UIGraphicsGetPDFContextBounds",tolua_UIKitFunction_UIGraphicsGetPDFContextBounds00);
  tolua_function(tolua_S,"UIGraphicsAddPDFContextDestinationAtPoint",tolua_UIKitFunction_UIGraphicsAddPDFContextDestinationAtPoint00);
  tolua_function(tolua_S,"UIGraphicsSetPDFContextDestinationForRect",tolua_UIKitFunction_UIGraphicsSetPDFContextDestinationForRect00);
  tolua_function(tolua_S,"UIGraphicsSetPDFContextURLForRect",tolua_UIKitFunction_UIGraphicsSetPDFContextURLForRect00);
  tolua_function(tolua_S,"CGAffineTransformFromString",tolua_UIKitFunction_CGAffineTransformFromString00);
  tolua_function(tolua_S,"CGPointFromString",tolua_UIKitFunction_CGPointFromString00);
  tolua_function(tolua_S,"CGRectFromString",tolua_UIKitFunction_CGRectFromString00);
  tolua_function(tolua_S,"CGSizeFromString",tolua_UIKitFunction_CGSizeFromString00);
  tolua_function(tolua_S,"NSStringFromCGAffineTransform",tolua_UIKitFunction_NSStringFromCGAffineTransform00);
  tolua_function(tolua_S,"NSStringFromCGPoint",tolua_UIKitFunction_NSStringFromCGPoint00);
  tolua_function(tolua_S,"NSStringFromCGRect",tolua_UIKitFunction_NSStringFromCGRect00);
  tolua_function(tolua_S,"NSStringFromCGSize",tolua_UIKitFunction_NSStringFromCGSize00);
  tolua_function(tolua_S,"NSStringFromUIEdgeInsets",tolua_UIKitFunction_NSStringFromUIEdgeInsets00);
  tolua_function(tolua_S,"NSStringFromUIOffset",tolua_UIKitFunction_NSStringFromUIOffset00);
  tolua_function(tolua_S,"UIEdgeInsetsFromString",tolua_UIKitFunction_UIEdgeInsetsFromString00);
  tolua_function(tolua_S,"UIOffsetFromString",tolua_UIKitFunction_UIOffsetFromString00);
  tolua_function(tolua_S,"UIEdgeInsetsEqualToEdgeInsets",tolua_UIKitFunction_UIEdgeInsetsEqualToEdgeInsets00);
  tolua_function(tolua_S,"UIEdgeInsetsInsetRect",tolua_UIKitFunction_UIEdgeInsetsInsetRect00);
  tolua_function(tolua_S,"UIOffsetEqualToOffset",tolua_UIKitFunction_UIOffsetEqualToOffset00);
  tolua_function(tolua_S,"UIAccessibilityPostNotification",tolua_UIKitFunction_UIAccessibilityPostNotification00);
  tolua_function(tolua_S,"UIAccessibilityIsVoiceOverRunning",tolua_UIKitFunction_UIAccessibilityIsVoiceOverRunning00);
  tolua_function(tolua_S,"UIAccessibilityIsClosedCaptioningEnabled",tolua_UIKitFunction_UIAccessibilityIsClosedCaptioningEnabled00);
  tolua_function(tolua_S,"UIAccessibilityRequestGuidedAccessSession",tolua_UIKitFunction_UIAccessibilityRequestGuidedAccessSession00);
  tolua_function(tolua_S,"UIAccessibilityIsGuidedAccessEnabled",tolua_UIKitFunction_UIAccessibilityIsGuidedAccessEnabled00);
  tolua_function(tolua_S,"UIAccessibilityIsInvertColorsEnabled",tolua_UIKitFunction_UIAccessibilityIsInvertColorsEnabled00);
  tolua_function(tolua_S,"UIAccessibilityIsMonoAudioEnabled",tolua_UIKitFunction_UIAccessibilityIsMonoAudioEnabled00);
  tolua_function(tolua_S,"UIAccessibilityZoomFocusChanged",tolua_UIKitFunction_UIAccessibilityZoomFocusChanged00);
  tolua_function(tolua_S,"UIAccessibilityRegisterGestureConflictWithZoom",tolua_UIKitFunction_UIAccessibilityRegisterGestureConflictWithZoom00);
  tolua_function(tolua_S,"UIAccessibilityConvertFrameToScreenCoordinates",tolua_UIKitFunction_UIAccessibilityConvertFrameToScreenCoordinates00);
  tolua_function(tolua_S,"UIAccessibilityConvertPathToScreenCoordinates",tolua_UIKitFunction_UIAccessibilityConvertPathToScreenCoordinates00);
  tolua_function(tolua_S,"NSTextAlignmentToCTTextAlignment",tolua_UIKitFunction_NSTextAlignmentToCTTextAlignment00);
  tolua_function(tolua_S,"NSTextAlignmentFromCTTextAlignment",tolua_UIKitFunction_NSTextAlignmentFromCTTextAlignment00);
  tolua_function(tolua_S,"UIGuidedAccessRestrictionStateForIdentifier",tolua_UIKitFunction_UIGuidedAccessRestrictionStateForIdentifier00);
 tolua_endmodule(tolua_S);
        [wax_globalLock() unlock];
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_UIKitFunction (lua_State* tolua_S) {
 return tolua_UIKitFunction_open(tolua_S);
};
#endif

