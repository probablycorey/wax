require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"
require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/exit_codes"
 
build_path = ENV['TM_FILEPATH']

while Dir[build_path + "/*.xcodeproj"].empty?
  if build_path == File.dirname(build_path)
    TextMate::UI.tool_tip "Could not find xcode project with build_path '#{ENV['TM_FILEPATH']}'"
    exit 1
  else
    build_path = File.dirname(build_path)
  end
end


system "cd '#{build_path}' && '#{ENV['TM_BUNDLE_PATH']}/Support/bin/hammer' -r"

#!/bin/bash
[[ -z "$TM_FILEPATH" ]] && TM_TMPFILE=$(mktemp -t pythonInTerm)
: "${TM_FILEPATH:=$TM_TMPFILE}"; cat >"$TM_FILEPATH"

: ${TM_LUA:=lua}
require_cmd "$TM_LUA"

esc () {
STR="$1" ruby <<"RUBY"
   str = ENV['STR']
   str = str.gsub(/'/, "'\\\\''")
   str = str.gsub(/[\\"]/, '\\\\\\0')
   print "'#{str}'"
RUBY
}

osascript <<- APPLESCRIPT
	tell app "Terminal"
	    launch
	    activate
	    do script "clear; cd '#{$build_path}' && '#{ENV['TM_BUNDLE_PATH']}/Support/bin/hammer' -r"
	    set position of first window to { 100, 100 }
	end tell
APPLESCRIPT

