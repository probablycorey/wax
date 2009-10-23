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
  TextMate::UI.tool_tip "No matches found for '#{word}'."
else  
  choices = refs.collect do |ref|
    value = case ref.type
    when DocSet::METHOD, DocSet::CLASS_METHOD
      result = ref.thing
      result = result.gsub(/:/, "_")
      result = result.chomp("_")
      result
    else
      ref.thing
    end
    
    {"thing" => ref.thing, "display" => value, "docset_type" => ref.type}
  end

  TextMate::UI.complete(choices, {:case_insensitive => false, :initial_filter => word.clean}) do |choice|
    return nil unless [DocSet::METHOD, DocSet::CLASS_METHOD].include? choice["docset_type"] #only add snippet to methods
      
    snippet = []
    
    snippet << "self" if word.to_s !~ /^:/ # a function definition, include self!
    
    choice["thing"].scan(/([^\:]+):/).each_with_index do |var, index|
      name = (index == 0) ? "first" : var.first
      snippet << "${#{index + 1}:#{name}}"
    end
        
    "(" + snippet.join(", ") + ")"
  end
end