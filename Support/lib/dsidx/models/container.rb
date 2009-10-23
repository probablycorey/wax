class Container < ActiveRecord::Base
  set_table_name :ZCONTAINER
  set_primary_key :Z_PK

  has_many :tokens, :foreign_key => :ZCONTAINER

  def token 
    Token.find(:first, :conditions => ["ZTOKENNAME = ? AND ZCONTAINER IS NULL", self.ZCONTAINERNAME])
  end
  
  def name
    self.ZCONTAINERNAME
  end
end
