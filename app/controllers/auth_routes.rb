#
get "/login" do
  @title = "Log in"
  haml :login
end

post "/login" do
  login    = params[ "login" ]
  password = params[ "password" ]

  User.login( login, password )

  current_name = User.current.name rescue nil

  if login == current_name
    flash[ :success ] = "User logged in"
    Visited.clear
  else
    flash[ :error ] = "Authentication error"
  end

  redirect Url.user
end

get "/logout" do
  User.logout
  Visited.clear
  flash[ :success ] = "User logged out"
  redirect Url.tango
end

get "/register" do
  @title = "New user"
  @register = Register.new

  haml :register
end

post "/verify" do
  @register = Register.new( params )
  @registration = nil
  
  begin
    if UserRegistration.create_from( @register )
      @title = "Verification"

      @registration = UserRegistration.first( :email.eql => @register.email )
      @registration.send_verification

      flash[ :success ] = "Created registration for email `#{@register.email}'.<br/>Now, read your regisration email and finish registration."
      redirect Url.user
    else
      flash[ :error ] = "Could not create registration for login `#{@register.login}' and email `#{@register.email}'"
      redirect Url.register
    end
  rescue Exception => e
    puts e.inspect
    puts e.backtrace * $/
    redirect Url.user
  end
end

get "/do/verify/:login/:code" do
  ur = UserRegistration.first( :login.eql => params[ :login ] )
  if ur && ur.verification == params[ :code ]
    ### TODO: What if someone made two registrations with same login
    ###       and different emails?
    new_user = User.create_with( ur.login, ur.password, ur.email, false )

    ### NOTE: Remove all same-login registrations
    UserRegistration.all( :login.eql => params[ :login ] ).each do |ur|
      ur.destroy
    end

    User.current = new_user

    flash[ :success ] = "Registration completed successfully."
  else
    flash[ :notice ] = "Somehow you could not finish your registration :("
  end

  redirect Url.user
end
