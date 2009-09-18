#
class UserRegistration
  #
  def self.create_from( register )
    if register.email && register.password_verified?
      ur = UserRegistration.first( :email.eql => register.email )
      
      ur ||= UserRegistration.new
      
      ur.login        = register.login
      ur.email        = register.email
      ur.password     = register.password
      ur.verification = Authentication.garble( register.email )
      ur.created_at   = Time.now

      ur.save
    end
  end

end
