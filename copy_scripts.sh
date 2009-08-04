#!/bin/sh

# copy_scripts.sh
# Lua
#
# Created by ProbablyInteractive on 5/27/09.
# Copyright 2009 Probably Interactive. All rights reserved.
#
# Gotta shove those files into the bundle!

mkdir -p "$PROJECT_DIR/Scripts"
mkdir -p "$PROJECT_DIR/Data/OinkScripts"

touch "$PROJECT_DIR/Scripts/init.lua"

rsync -v -r --delete "$PROJECT_DIR/Data" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH" > /dev/null