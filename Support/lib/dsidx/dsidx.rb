require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"
require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/exit_codes"

require "rubygems"
require "active_record" # Weird hack to get it to work in leopard

class Dsidx
  DOCUMENTATION_PATH = Dir["/Developer/Platforms/iPhoneOS.platform/Developer/Documentation/DocSets/*.docset/Contents/Resources/docSet.dsidx"].last
  
  if DOCUMENTATION_PATH.empty?
    TextMate::UI.tool_tip "Could not find iPhone documentation database."
  end

  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => DOCUMENTATION_PATH)
  # ActiveRecord::Base.logger = Logger.new(STDOUT)

  LANGUAGES = {"1" => "Objective-C", "2" => "C"}
  # ActiveRecord::Base.connection.execute("SELECT * FROM ZAPILANGUAGE").each {|o| LANGUAGES[o["Z_PK"]] = o["ZFULLNAME"]}

  require File.dirname(__FILE__) + "/models/token"
  require File.dirname(__FILE__) + "/models/container"
  
  def self.methods_for_protocol(name)
    object = Container.find(:first, :conditions => ["ZCONTAINERNAME = ?", name])
    
    if not object 
      TextMate::UI.tool_tip "Could not find object named '#{name}'"
      exit 1
    elsif not object.token.protocol? 
      TextMate::UI.tool_tip "'#{name}' is not a protocol"
      exit 1
    end
    
    declarations = []
    for token in object.tokens.select {|t| t.protocol_method?}
      declarations << token.meta_info.declaration.gsub(/<\/?[^>]+\/?>/, "")
    end
    
    declarations
  end
end