#
require 'md5'

class Authentication
  def self.authenticate?( user, password )
    user.password == garble( password )
  end

  def self.garble( password )
    MD5::md5( password ).to_s
  end
end
