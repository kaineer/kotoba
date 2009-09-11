#
#
#
#
#

class UserScore
  include DataMapper::Resource

  property :id,       Serial
  property :user_id,  Integer, :key => true

  property :tango_id, Integer
end
