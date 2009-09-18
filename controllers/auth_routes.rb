#
require 'rack-flash'
require 'lib/register'


enable :sessions
use Rack::Flash


post "/login" do
  login    = params[ "login" ]
  password = params[ "password" ]

  User.login( login, password )

  current_name = User.current.login rescue nil

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
  @register = Register.new

  haml :register
end

post "/verify" do
  @register = Register.new( params )
  if UserRegistration.create_from( @register )
    flash[ :notice ] = "Created registration for email: #{@register.email}"
  else
    flash[ :notice ] = "Could not create registration for email: #{@register.email}"
  end

  haml :register
end
