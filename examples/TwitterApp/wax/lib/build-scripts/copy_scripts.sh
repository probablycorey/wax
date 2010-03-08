#!/bin/zsh

# copy_scripts.sh
# Lua
#
# Created by Corey Johnson on 5/27/09.
# Copyright 2009 Probably Interactive. All rights reserved.

# copy everything in the data dir to the app (doesn't just have to be lua files, can be images, sounds, etc...)
rsync -r --delete "$PROJECT_DIR/data" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH" > /dev/null

# copies the wax scripts over
rsync -r --delete "$PROJECT_DIR/wax/lib/wax-scripts/" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/data/scripts/wax" > /dev/null

# luac.lua doesn't work for 64 bit lua
# if [[ $CONFIGURATION = "Distribution" ]]; then
#     ${LUA:=/usr/bin/env lua}
#     $LUA "$PROJECT_DIR/wax/build-scripts/luac.lua" init.dat "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/data/scripts/" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/data/scripts/init.lua" -L "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/data/scripts"/**/*.lua
#     rm -rf "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/data/scripts/"*
#     mv init.dat "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/data/scripts/"
# fi