//
//  WaxCGContext.h
//  EmpireState
//
//  Created by Corey Johnson on 10/5/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"

int luaopen_wax_CGContext(lua_State *L);
static int currentContext(lua_State *L);

static int translate(lua_State *L);

static int setAlpha(lua_State *L);
static int setFillColor(lua_State *L);
static int setStrokeColor(lua_State *L);

static int fillRect(lua_State *L);
static int fillPath(lua_State *L);