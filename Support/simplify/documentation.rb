require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"
require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/exit_codes"

require "wax/doc_set"
require "wax/current_word"
include Wax

line = ENV['TM_CURRENT_LINE']
col = ENV['TM_LINE_INDEX'].to_i
word = CurrentWord.get(line, col)
refs = DocSet.search(word.query, *word.filters)

if refs.empty?
  TextMate::UI.tool_tip "No Documentation found for '#{word}'."
else
  DocSet.show_document(refs)
end