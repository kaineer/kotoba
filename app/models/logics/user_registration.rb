#
class UserRegistration
  #
  def self.create_from( register )
    if User.first( :login.eql => register.login )
      return nil
    end

    if User.first( :email.eql => register.email )
      return nil
    end

    if register.email && register.password_verified?
      ur = UserRegistration.first( :email.eql => register.email )
      
      ur ||= UserRegistration.new
      
      ur.login        = register.login
      ur.email        = register.email
      ur.password     = register.password
      ur.verification = Authentication.garble( register.email )
      ur.created_at   = Time.now

      ur.save

      return true
    end

    nil
  end

  def send_verification
    body = <<EOT
Hello, #{self.login}!

You, (or another person) entered your email 
into registration form at #{Site.base}#{Url.login}.

If you still wish to proceed with your registration,
click the link below:

#{Site.base}#{Url.do_verify}/#{self.login}/#{self.verification}

EOT

    Pony.mail(
              :to      => self.email,
              :from    => Site.email,
              :subject => "[kotoba.registration]",
              :body    => body
              )
  end
end
