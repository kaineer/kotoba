#
=begin
require 'rack-flash'
require 'lib/register'


enable :sessions
use Rack::Flash

before do
  Session.instance = session
end
=end

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
    flash[ :notice ] = "User logged in"
  end

  redirect Url.user
end

get "/logout" do
  User.logout
  Visited.clear
  flash[ :notice ] = "User logged out"
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
  
  if UserRegistration.create_from( @register )
    @title = "Verification"

    @registration = UserRegistration.first( :email.eql => @register.email )

    flash[ :notice ] = "Created registration for email `#{@register.email}'"
    haml :verify
  else
    flash[ :notice ] = "Could not create registration for login `#{@register.login}' and email `#{@register.email}'"
    redirect Url.register
  end
end