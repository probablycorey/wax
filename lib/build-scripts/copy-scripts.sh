#!/bin/zsh

# Created by Corey Johnson

WAX_SCRIPTS_DIR="scripts"
SOURCE_SCRIPTS_DIR="$PROJECT_DIR/$WAX_SCRIPTS_DIR"
DESTINATION_SCRIPTS_DIR="$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/$WAX_SCRIPTS_DIR"

mkdir -p "$SOURCE_SCRIPTS_DIR"
rm -rf "$DESTINATION_SCRIPTS_DIR"
mkdir -p "$DESTINATION_SCRIPTS_DIR"

if [ $WAX_COMPILE_SCRIPTS ]; then
  echo "note: Wax is using compiled Lua scripts."
  # This requires that you run a special build of lua. Since snow leopard is 64-bit 
  # and iOS is 32-bit, luac files compiled on snow leopard won't work on iOS
  
  lua "$PROJECT_DIR/wax/lib/build-scripts/luac.lua" wax wax.dat "$PROJECT_DIR/wax/lib/stdlib/" "$PROJECT_DIR/wax/lib/stdlib/init.lua" -L "$PROJECT_DIR/wax/lib/stdlib"/**/*.lua
  lua "$PROJECT_DIR/wax/lib/build-scripts/luac.lua" "" AppDelegate.dat "$SOURCE_SCRIPTS_DIR/" "$SOURCE_SCRIPTS_DIR/AppDelegate.lua" -L "$SOURCE_SCRIPTS_DIR"/**/*.lua
  mv AppDelegate.dat "$DESTINATION_SCRIPTS_DIR"
else
  # copy everything in the data dir to the app (doesn't just have to be lua files, can be images, sounds, etc...)
  echo $DESTINATION_SCRIPTS_DIR
  cp -r "$PROJECT_DIR/wax/lib/stdlib" "$DESTINATION_SCRIPTS_DIR/wax"
  cp -r "$SOURCE_SCRIPTS_DIR/" "$DESTINATION_SCRIPTS_DIR"
fi

# This forces the data dir to be reloaded on the device
touch "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH"/*