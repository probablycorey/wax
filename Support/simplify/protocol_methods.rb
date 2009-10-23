require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"
require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/exit_codes"

require "wax/current_word"
require "wax/objc_to_lua"
require "dsidx/dsidx"

include Wax

word = $stdin.gets
if not word or word.empty?
  TextMate::UI.tool_tip "Select the name of the protocol first. (TODO... if nothing selected, let user type in protocol)"
  exit 1
end
word.strip

declarations = Dsidx.methods_for_protocol(word)

if declarations.empty?
  TextMate::UI.tool_tip "No methods found for '#{word}'."
else
  for declaration in declarations
    puts ObjcToLua.function(declaration)
    puts
  end
end