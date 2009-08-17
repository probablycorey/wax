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

window = UI.Application:sharedApplication():keyWindow()
window:setBackgroundColor(UI.Color:orangeColor())

label = UI.Label:initWithFrame(CGRect(0, 100, 320, 40))
label:setFont(UI.Font:boldSystemFontOfSize(30))
label:setColor(UI.Color:orangeColor())
label:setText("LOOK! IT WORKED!")
label:setTextAlignment(UITextAlignmentCenter)

window:addSubview(label)

-- start coding your stuff!
INITFILE
fi

# copy the oink lua scripts into the dir... unless the oink directory already exists
destPath="$PROJECT_DIR/data/oink"
if [ ! -d $destPath ]; then
  cp -r "$PROJECT_DIR/`dirname $0`/scripts/" $destPath
fi

rsync -v -r --delete "$PROJECT_DIR/data" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH" > /dev/null