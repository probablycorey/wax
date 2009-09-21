#!/bin/sh

# copy_scripts.sh
# Lua
#
# Created by Corey Johnson on 5/27/09.
# Copyright 2009 Probably Interactive. All rights reserved.

# copy everything in the data dir to the app (doesn't just have to be lua files, can be images, sounds, etc...)
rsync -v -r --delete "$PROJECT_DIR/data" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH" > /dev/null

# copies the wax scripts over
rsync -v -r "$PROJECT_DIR/wax/wax-scripts/" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/data/scripts/wax" > /dev/null