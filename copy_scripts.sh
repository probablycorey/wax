#!/bin/sh

# copy_scripts.sh
# Lua
#
# Created by ProbablyInteractive on 5/27/09.
# Copyright 2009 Probably Interactive. All rights reserved.
#
# Gotta shove those files into the bundle!

mkdir -p "$PROJECT_DIR/data/scripts"

initPath="$PROJECT_DIR/data/scripts/init.lua"
if [ ! -f $initPath ]; then
  cat <<INITFILE >> $initPath
require "oink"

# start coding your stuff!
INITFILE
fi

# copy the oink lua scripts into the dir... unless the oink directory already exists
destPath="$PROJECT_DIR/data/oink"
if [ ! -d $destPath ]; then
  cp -r "$PROJECT_DIR/`dirname $0`/scripts/" $destPath
fi

rsync -v -r --delete "$PROJECT_DIR/Data" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH" > /dev/null