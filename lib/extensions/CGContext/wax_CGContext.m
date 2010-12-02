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

static int currentContext(lua_State *L) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    wax_fromObjc(L, @encode(CGContextRef), &context);
    if (lua_gettop(L) > 1 && lua_isfunction(L, 1)) { // Function! 
        CGContextSaveGState(context);
        lua_call(L, 1, 1);
        CGContextRestoreGState(context);
    }

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

// fillRect(context, CGRect(0,0,10,10))
static int fillRect(lua_State *L) {
    CGContextRef c = (CGContextRef)lua_topointer(L, 1);
    CGRect *rect = wax_copyToObjc(L, @encode(CGRect), 2, nil);
    CGContextFillRect(c, *rect);
    free(rect);
    
    return 0;
}

// fillRoundedRect(context, CGRect(0,0,10,10), 10)
static int fillRoundedRect(lua_State *L) {
    CGContextRef c = (CGContextRef)lua_topointer(L, 1);
    CGRect *rect = wax_copyToObjc(L, @encode(CGRect), 2, nil);
	CGFloat radius = luaL_checknumber(L, 3);

    CGFloat width = CGRectGetWidth(*rect);
    CGFloat height = CGRectGetHeight(*rect);
    
    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width/2.0) {
        radius = width/2.0;
	}
    if (radius > height/2.0) {
        radius = height/2.0;  
	}
    
    CGFloat minx = CGRectGetMinX(*rect);
    CGFloat midx = CGRectGetMidX(*rect);
    CGFloat maxx = CGRectGetMaxX(*rect);
    CGFloat miny = CGRectGetMinY(*rect);
    CGFloat midy = CGRectGetMidY(*rect);
    CGFloat maxy = CGRectGetMaxY(*rect);
    CGContextMoveToPoint(c, minx, midy);
    CGContextAddArcToPoint(c, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(c, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(c, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(c, minx, maxy, minx, midy, radius);
    CGContextClosePath(c);
    CGContextDrawPath(c, kCGPathFill);
	
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

// drawLinearGradient(context, startPoint, endPoint, colors, locations)
//    FOR SOME REASON THIS DOESN'T WORK WITH GRAY/BLACK COLORS... WTF!
static int drawLinearGradient(lua_State *L) {
    CGContextRef c = (CGContextRef)lua_topointer(L, 1);
    CGPoint *start = wax_copyToObjc(L, @encode(CGPoint), 2, nil);
    CGPoint *end = wax_copyToObjc(L, @encode(CGPoint), 3, nil);    
    NSArray *colors = wax_copyToObjc(L, @encode(NSArray *), 4, nil);
    
    CGFloat *locations = malloc(lua_objlen(L, 5) * sizeof(CGFloat));

    for (int i = 0; i < lua_objlen(L, 5); i++) {
        lua_rawgeti(L, 5, i + 1);
        locations[i] = luaL_checknumber(L, -1);
        lua_pop(L, 1);
    }
    
    
    CGGradientRef gradient = CGGradientCreateWithColors(nil, *(CFArrayRef *)colors, nil);
  
    CGContextDrawLinearGradient(c, gradient, *start, *end, 0);
    
    free(start);
    free(end);
    free(colors);
    free(locations);
    CGGradientRelease(gradient);

    return 0;
}

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
	{"fillRoundedRect", fillRoundedRect},
    {"fillPath", fillPath},
    {"drawLinearGradient", drawLinearGradient},
    
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
