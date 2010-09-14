#!/bin/zsh

# copy_scripts.sh
# Lua
#
# Created by Corey Johnson on 5/27/09.
# Copyright 2009 Probably Interactive. All rights reserved.

# copy everything in the data dir to the app (doesn't just have to be lua files, can be images, sounds, etc...)
rsync -C -exclude .svn -r --delete "$PROJECT_DIR/data" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH" > /dev/null

# copies the wax scripts over
rsync -C -exclude .svn -r --delete "$PROJECT_DIR/wax/lib/wax-scripts/" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/data/scripts/wax" > /dev/null

if [[ $CONFIGURATION = "Debug" ]]; then
    LUAC=$PROJECT_DIR/wax/bin/luac
    for f in `find $BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/data/scripts | grep lua$`
    do
        echo "Compiling $f..."
        DIR=`dirname $f`
        NAME=`basename $f .lua`
        $LUAC -s -o "$DIR/$NAME.dat" $f
        rm $f
    done

    cd $BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH && zip -r resources.dat data/ && rm -rf data/
    
    touch -cm $BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH
fi
