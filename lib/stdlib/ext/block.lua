function toblock(func, paramTypes)
    if paramTypes == nil then
        return toobjc(func):luaVoidBlock()
   else
       return toobjc(func):luaBlockWithParamsTypeArray(paramTypes)
   end
end