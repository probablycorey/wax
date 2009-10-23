require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/ui'

result = `${TM_LUAC:-/usr/local/bin/luac} -p "$TM_FILEPATH" 2>&1`

if not result.empty?
  TextMate.go_to :line => $1 if result =~ /:(\d+):/
  TextMate::UI.tool_tip(result)
else
  TextMate::UI.tool_tip('<h1 style="background:green; color:whites; -webkit-border-radius:15px; padding:1em; -webkit-transform:rotate(-5deg); margin-top:100px">Valid Lua!</h1>', {:transparent => true, :format => :html})
end