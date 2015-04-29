#!/usr/bin/env lua
print("start complie lua 64")
-- usage: lua luac.lua module-name output.file base_dir starting-file.lua [-L [other-files.lua]*]
--
-- base_dir: The root for all the lua files. So folder modules can be used
--
-- creates a precompiled chunk that preloads all modules listed after
-- -L and then runs all programs listed before -L.
--
-- assumptions:
--    file xxx.lua contains module xxx
--    '/' is the directory separator (could have used package.config)
--    int and size_t take 4 bytes (could have read sizes from header)
--    does not honor package.path
--
-- Luiz Henrique de Figueiredo <lhf@tecgraf.puc-rio.br>
-- Tue Aug  5 22:57:33 BRT 2008
-- This code is hereby placed in the public domain.

local MARK = "////////"
local NAME = "luac"

local MODULE_NAME = table.remove(arg, 1)
local OUTPUT = table.remove(arg, 1)
local BASE_DIR = table.remove(arg, 1)
NAME = "=("..NAME..")"

local argCount = #arg
local executableIndex = n
local b

for i = 1, argCount do
 if arg[i] == "-L" then executableIndex = i - 1 break end
end

if executableIndex + 2 <= argCount then b = "local t=package.preload;\n" else b = "local t;\n" end

for i = executableIndex + 2, argCount do
 local requireString = string.gsub(arg[i], "^" .. string.gsub(BASE_DIR, "(%W)", "%%%1"), "")
 requireString = string.gsub(requireString,"^[\./]*(.-)\.lua$", "%1")
 requireString = string.gsub(requireString, "/", ".")
 requireString = string.gsub(requireString, ".init$", "") -- if it is an init file within a directory... ignore it!
 if MODULE_NAME and #MODULE_NAME > 0 then requireString = MODULE_NAME .. "." .. requireString end
 
 b = b.."t['"..requireString.."']=function()end;\n"
 arg[i]=string.sub(string.dump(assert(loadfile(arg[i]))), 13) -- string.sub Removes header from file 
end
b = b.."t='"..MARK.."';\n"

for i = 1, executableIndex do
  b = b.."(function()end)();\n"
  arg[i]=string.sub(string.dump(assert(loadfile(arg[i]))), 13) -- string.sub Removes header from file  
end

b = string.dump(assert(loadstring(b, NAME)))
local x, y = string.find(b, MARK)
-- 64
b = string.sub(b, 1, x - 6 - 4).."\0"..string.sub(b, y + 2, y + 5) -- WTF does this do?

-- 32
-- b = string.sub(b, 1, x - 6).."\0"..string.sub(b, y + 2, y + 5) -- WTF does this do?
-- print("luac complie 32 bit lua")

f = assert(io.open(OUTPUT, "wb"))

assert(f:write(b))

for i = executableIndex + 2, argCount do
  assert(f:write(arg[i]))
end

for i=1,executableIndex do
  assert(f:write(arg[i]))
end

-- 64
assert(f:write(string.rep("\0", 3 * 8)))
print("end complie lua 64")

-- 32
-- assert(f:write(string.rep("\0", 12)))
-- print("luac complie 32 bit lua")
assert(f:close())