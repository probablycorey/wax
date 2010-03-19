//
//  WaxCGContext.m
//  EmpireState
//
//  Created by Corey Johnson on 10/5/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "wax_CGContext.h"

#import "wax_instance.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

#define METATABLE_NAME "wax.CGContext"

static const struct luaL_Reg metaFunctions[] = {
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"currentContext", currentContext},
    {"imageContext", imageContext},
    {"imageFromContext", imageFromContext},
    
    {"translate", translate},
    
    {"setFillColor", setFillColor},
    {"setStrokeColor", setStrokeColor},    
    {"setAlpha", setAlpha},
    
    {"fillRect", fillRect},
    {"fillPath", fillPath},

    {NULL, NULL}
};

int luaopen_wax_CGContext(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_newmetatable(L, METATABLE_NAME);        
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, METATABLE_NAME, functions);    
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}


static int currentContext(lua_State *L) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    wax_fromObjc(L, @encode(CGContextRef), &context);
    
    return 1;
}

static int imageContext(lua_State *L) {
    int startTop = lua_gettop(L);
    int width = luaL_checknumber(L, 1);
    int height = luaL_checknumber(L, 2);

    UIGraphicsBeginImageContext(CGSizeMake(width, height));    
    lua_call(L, 0, LUA_MULTRET);
    UIGraphicsEndImageContext();
    
    int nresults = lua_gettop(L) - startTop + 1; // Add one because the function is popped

    return nresults;
}

static int imageFromContext(lua_State *L) {
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    wax_instance_create(L, image, NO);
    
    return 1;
}

static int translate(lua_State *L) {
    CGContextRef c = (CGContextRef)lua_topointer(L, 1);
    CGFloat x = lua_tonumber(L, 2);
    CGFloat y = lua_tonumber(L, 3);
    
    CGContextTranslateCTM(c, x, y);

    return 0;
}

static int setAlpha(lua_State *L) {
    CGContextRef c = (CGContextRef)lua_topointer(L, 1);
    double alpha = lua_tonumber(L, 2);
    CGContextSetAlpha(c, alpha);
    
    return 0;
}

// Can take percent values (0 - 1) or a UIColor
// setFillColor(context, r, g, b [, a])
// setFillColor(context, color)
static int setFillColor(lua_State *L) {
    CGContextRef c = (CGContextRef)lua_topointer(L, 1);
    
    if (lua_gettop(L) >= 4) {
        double r = luaL_checknumber(L, 2);
        double g = luaL_checknumber(L, 3);
        double b = luaL_checknumber(L, 4);    
        double a = lua_isnoneornil(L, 5) ? 1 : luaL_checknumber(L, 5);
        CGContextSetRGBFillColor(c, r, g, b, a);        
    }
    else {
        UIColor **color = wax_copyToObjc(L, @encode(UIColor *), 2, nil);
        CGContextSetFillColorWithColor(c, [*color CGColor]);
        free(color);
    }
    
    return 0;
}

// Can take percent values (0 - 1) or a UIColor
// setStrokeColor(context, r, g, b [, a])
// setStrokeColor(context, color)
static int setStrokeColor(lua_State *L) {
    CGContextRef c = (CGContextRef)lua_topointer(L, 1);
    
    if (lua_gettop(L) >= 4) {
        double r = luaL_checknumber(L, 2);
        double g = luaL_checknumber(L, 3);
        double b = luaL_checknumber(L, 4);    
        double a = lua_isnoneornil(L, 5) ? 1 : luaL_checknumber(L, 5);
        CGContextSetRGBStrokeColor(c, r, g, b, a);        
    }
    else {
        UIColor **color = wax_copyToObjc(L, @encode(id), 2, nil);
        CGContextSetStrokeColorWithColor(c, [*color CGColor]);
        free(color);
    }
    
    return 0;
}

// fillRect(context, CGRect(0,0,10,10)
static int fillRect(lua_State *L) {
    CGContextRef c = (CGContextRef)lua_topointer(L, 1);
    CGRect *rect = wax_copyToObjc(L, @encode(CGRect), 2, nil);
    CGContextFillRect(c, *rect);
    free(rect);
    
    return 0;
}

// fillPath(context, pointArray)
static int fillPath(lua_State *L) {
    CGContextRef c = (CGContextRef)lua_topointer(L, 1);
    CGContextBeginPath(c);
    
    int indexCount = lua_objlen(L, 2);
    if (indexCount % 2 != 0) luaL_error(L, "Requires an even number of indexes for points.");

    int pointCount = indexCount / 2;
    CGPoint *points = calloc(pointCount, sizeof(CGPoint));
    
    for (int i = 0; i < pointCount; i++) {
        int arrayIndex = (i * 2) + 1;
        lua_rawgeti(L, 2, arrayIndex);
        lua_rawgeti(L, 2, arrayIndex + 1);
        points[i].x = luaL_checknumber(L, -2);
        points[i].y = luaL_checknumber(L, -1);
        lua_pop(L, 2);
    }    
    CGContextAddLines(c, points, pointCount);
    CGContextDrawPath(c, kCGPathFill);
    
    free(points);
    
    return 0;
}