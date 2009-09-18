#
enable :sessions


get "/admin/registrations" do
  if User.admin?
    @registrations = UserRegistration.all
    haml :"admin/registrations"
  else
    flash[ :notice ] = "You've no rights to admin here"
    redirect Url.user
  end
end

post "/admin/verify" do
  if User.admin?

    @registration = UserRegistration.first( :email => params[ :email ] )
    if @registration.verification == params[ :verification ]
      User.create_with( 
                       @registration.login,
                       @registration.password,
                       @registration.email,
                       false )

      @registration.destroy
    end

    redirect "/admin/registrations"
  else
    flash[ :notice ] = "You've no rights to admin here"
    redirect Url.user
  end
end
