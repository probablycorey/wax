#!/bin/zsh

#manual compile set path
PROJECT_DIR="../../lib"

###32 bit stdlib
# Compiles the wax stdlib into one file
./lua32 "$PROJECT_DIR/build-scripts/luac32.lua" wax wax32.dat "$PROJECT_DIR/stdlib/" "$PROJECT_DIR/stdlib/init.lua" -L  "$PROJECT_DIR/stdlib"/**/*.lua
#"$PROJECT_DIR/stdlib"/*.lua

lua32Byte=$(hexdump -v -e '1/1 "%d,"' wax32.dat)
# Dumps the compiled file into a byte array, then it places this into the source code
# cat > "$PROJECT_DIR/wax_stdlib32.h" <<EOF
# // DO NOT MODIFY
# // This is auto generated, it contains a compiled version of the wax stdlib
# #define WAX_STDLIB {$lua32Byte}
# EOF

# clean up
#rm wax32.dat

###64 bit stdlib
# Compiles the wax stdlib into one file
./lua64 "$PROJECT_DIR/build-scripts/luac64.lua" wax wax64.dat "$PROJECT_DIR/stdlib/" "$PROJECT_DIR/stdlib/init.lua" -L  "$PROJECT_DIR/stdlib"/**/*.lua
#"$PROJECT_DIR/stdlib"/*.lua

lua64Byte=$(hexdump -v -e '1/1 "%d,"' wax64.dat)
# Dumps the compiled file into a byte array, then it places this into the source code
# cat > "$PROJECT_DIR/wax_stdlib64.h" <<EOF
# // DO NOT MODIFY
# // This is auto generated, it contains a compiled version of the wax stdlib
# #define WAX_STDLIB {$lua64Byte}
# EOF

# clean up
#rm wax64.dat

var=`date "+%Y-%m-%d %H:%M:%S"`
cat > "$PROJECT_DIR/wax_stdlib.h" <<EOF
// DO NOT MODIFY
// This is auto generated, it contains a compiled version of the wax stdlib
//recompiled 32 and new 64 bit by junzhan<junzhan.yzw@taobao.com> ${var}
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
#warning @"64 bit arm"
#define WAX_STDLIB {$lua64Byte}

#else
    #warning @"32 bit arm"
// DO NOT MODIFY
// This is auto generated, it contains a compiled version of the wax stdlib
#define WAX_STDLIB {$lua32Byte}
#endif
EOF



