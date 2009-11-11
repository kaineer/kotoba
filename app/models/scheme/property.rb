#
#
#
#
#
class Property
  include DataMapper::Resource

  property :id,        Serial
  property :parent_id, Integer
  
  property :name,      String,  :key => true
  property :value,     String
end
