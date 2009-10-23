class TokenType < ActiveRecord::Base
  set_table_name :ZTOKENTYPE
  set_primary_key :Z_PK
  
  def name; self.ZTYPENAME; end
end

class Token < ActiveRecord::Base
  TYPES = {}
  TokenType.find(:all).each {|o| TYPES[o.id] = o.name}  
  TYPE_NAMES = TYPES.invert

  set_table_name :ZTOKEN
  set_primary_key :Z_PK
  
  belongs_to :container, :foreign_key => :ZCONTAINER
  belongs_to :meta_info, :class_name => "TokenMetaInfo", :foreign_key => :ZMETAINFORMATION  
  has_many :parameters, :foreign_key => :Z14PARAMETERS, :order => "ZORDER"

  def name; self.ZTOKENNAME; end
  def language; LANGUAGES[self.ZLANGUAGE]; end
  def type; TYPES[self.ZTOKENTYPE]; end
  
  def global?; type == "data"; end
  def protocol_property?; type == "intf"; end  
  def property?; type == "instp"; end  
  def class_method?; type == "clm"; end    
  def type?; type == "tdef"; end
  def category?; type == "cat"; end    
  def protocol_method?; type == "intfm"; end  
  def instance_method?; type == "instm"; end  
  def function?; type == "func"; end
  def macro?; type == "macro"; end
  def class?; type == "cl"; end
  def const?; type == "econst"; end
  def protocol?; type == "intf"; end
  def tag?; type == "tag"; end
  
  def method?; instance_method? || class_method?; end  
end

class TokenMetaInfo < ActiveRecord::Base
  set_table_name :ZTOKENMETAINFORMATION
  set_primary_key :Z_PK
  
  def declaration; self.ZDECLARATION; end
  def description; self.ZABSTRACT; end
  def return_description
    if self.ZRETURNVALUE
      DB[:ZRETURNVALUE][:Z_PK => self.ZRETURNVALUE][:ZABSTRACT]
    else
      nil
    end
  end
end

class Parameters < ActiveRecord::Base
  set_table_name :ZPARAMETER
  set_primary_key :Z_PK
  
  def order; self.ZORDER; end
  def name; self.ZPARAMETERNAME; end
  def description; self.ZABSTRACT; end
end