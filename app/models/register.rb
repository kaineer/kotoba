class Register
  def initialize( params = {} )
    @login = params[ :login ].to_s
    @email = params[ :email ].to_s
    @password = params[ :password ].to_s
    @repeat   = params[ :repeat ].to_s
  end

  attr_reader :login, :email
  
  def password_verified?
    @password.to_s == @repeat.to_s
  end

  def password
    password_verified? ? @password : nil
  end
end
