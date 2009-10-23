require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"
require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/exit_codes"

require "wax/doc_set"
include Wax

word = TextMate::UI.request_string(:prompt => "Search documentation for...", :button1 => "Search" )
refs = DocSet.search(word)

if refs.empty?
  TextMate::UI.tool_tip "No Documentation found for '#{word}'."
else
  TextMate::UI.tool_tip "No Documentation found for '#{word}'."
  DocSet.show_document(refs)
end