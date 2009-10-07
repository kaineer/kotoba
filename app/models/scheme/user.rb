#
#
#
#
#
class User
  include DataMapper::Resource

  property :id,       Serial
  property :login,    String
  property :email,    String
  property :password, String
  property :admin,    Boolean

  has n, :user_bookmarks
end # of properties
