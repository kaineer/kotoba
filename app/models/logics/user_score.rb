#
#
#

class UserScore
  def self.find_or_create( user_id )
    return nil unless user_id
    first( :user_id.eql => user_id ) || create( :user_id => user_id )
  end
end
