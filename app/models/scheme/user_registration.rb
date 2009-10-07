#
class UserRegistration
  include DataMapper::Resource

  property :id,           Serial
  property :login,        String
  property :email,        String
  property :password,     String
  property :verification, String
  property :created_at,   Time
end

