#
class UserBookmark
  include DataMapper::Resource

  property :id,        Serial
  property :user_id,   Integer
  property :tango_id,  Integer

  belongs_to :user
end
