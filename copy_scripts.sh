#!/bin/sh

# copy_scripts.sh
# Lua
#
# Created by ProbablyInteractive on 5/27/09.
# Copyright 2009 Probably Interactive. All rights reserved.
#
# Gotta shove those files into the bundle!

mkdir -p "$PROJECT_DIR/data/scripts"
touch "$PROJECT_DIR/data/scripts/init.lua"

ln -l `dirname $0`/scripts "$PROJECT_DIR/data/oink-scripts"

rsync -v -r --delete "$PROJECT_DIR/Data" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH" > /dev/null