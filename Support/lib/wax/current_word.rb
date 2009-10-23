require "wax/doc_set"

module Wax
  Word = Struct.new(:raw, :query, :filters)
  class Word
    def to_s; self.raw; end
    def clean; self.raw.gsub(/[^\w_]/, ""); end
  end
  
  class CurrentWord
    BEFORE_WORD_PATTERN = /[\w\.]*:?/
    AFTER_WORD_PATTERN = /[\w\.]*:?/
    
    def self.get(line, col)
      before_match = line[0...col].reverse[BEFORE_WORD_PATTERN, 0] || ""
      after_match = line[col..-1][AFTER_WORD_PATTERN, 0] || ""
      word = before_match.reverse + after_match
            
      query = word.dup 
      filters = []
      case query
      when /^[A-Z]{2,}\.\w+/ # Class
        query.tr! ".", ""
        query = (query =~ /:$/) ? query.chop : query + "*" # Wildcard!  
        filters = [DocSet::CLASS]
      when /^[A-Z]{2,}\w+/ # Constants and protocols
        query += "*" # Wildcard!  
        
        if ENV['TM_SCOPE'] =~ /string\./i #inside strings, we usually only want classes or protocols          
          filters = [DocSet::PROTOCOL, DocSet::CLASS]
        else        
          filters = [DocSet::PROTOCOL, DocSet::ENUM]
        end
      when /^(:|[a-z])/
        query.gsub!(/.*?:/, "")
        query.gsub! "_", ":"
        query += "*"
        filters = [DocSet::METHOD, DocSet::CLASS_METHOD]
      end

      return Word.new(word, query, [*filters])
    end
  end
end