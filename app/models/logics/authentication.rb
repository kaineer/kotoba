#
require 'md5'

class Authentication
  def self.authenticate?( user, password )
    user.password == garble( user.name + password )
  end

  def self.garble( string )
    MD5::md5( string + salt ).to_s
  end

protected

  def self.salt
    "6dc241712d34d63cb"
  end
end
