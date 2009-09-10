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


class UserScore
  def self.find_or_create( user_id )
    return nil unless user_id
    first( :user_id.eql => user_id ) || create( :user_id => user_id )
  end
end
