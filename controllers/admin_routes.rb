#
enable :sessions


get "/admin/registrations" do
  @registrations = UserRegistration.all

  haml :"admin/registrations"
end

post "/admin/verify" do
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
end
