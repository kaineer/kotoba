class Register
  def initialize( params = {} )
    @login = params[ :login ].to_s
    @email = params[ :email ].to_s
    @password = params[ :password ].to_s
    @repeat   = params[ :repeat ].to_s
  end

  attr_reader :login
  
  def password_verified?
    @password.to_s == @repeat.to_s
  end

  def password
    password_verified? ? @password : nil
  end

  def email
    case @email
    when /^[-\w.]+$/ then "#{@email}@gmail.com"
    when /^[-\w.]+@gmail\.com$/ then @email
    else nil
    end
  end

  def email_prefix
    self.email.to_s[ /^[-\w.]+/ ]
  end
end
