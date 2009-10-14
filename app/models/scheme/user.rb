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
  has 1, :user_score
  has 1, :user_ui, :class_name => "UserUI"
end # of properties
