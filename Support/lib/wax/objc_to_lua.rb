class ObjcToLua
  def self.function(declaration)
    lua_function = declaration.clone
    lua_function.gsub!(/^(\-|\+)\s*/, "") # Remove class/instance method stuff
    lua_function.gsub!(/^\([^\)]+\)\s*/, "") # Remove return type
    params = lua_function.scan(/:\([^\)]+\)\s*(\w+)\s*/)
    lua_function.gsub!(/:\([^\)]+\)\s*(\w+)\s*/, "_") # replace :'s with _'s
    lua_function.gsub!(/_$/, "") # get rid of final _ if it exists

    "function #{lua_function}(#{params.join(', ')})\nend\n"
  end
end