#
#
#
#
#

require 'rubygems'
require 'sinatra'
require 'yaml'
require 'haml'
require 'models'

enable :sessions

#### Source: [ http://blog.kabisa.nl/2009/02/16/flash-messages-for-sinatra/ ]
def flash
  session[:flash] = {} if session[:flash] && session[:flash].class != Hash
  session[:flash] ||= {}
end

def render( method, *args )
  html = self.__send__( method, *args )
  flash.clear
  html
end

before do
  Session.instance = session
end

get '/logout' do
  User.logout
  
  redirect '/0'
end

get '/:id' do
  @user = User.current
  @tango_id = params[ :id ].to_i
  @tango = Tango[ @tango_id ]

  @visited = session[ "visited" ] || []
  @visited = @visited.sort.uniq
  @visited = @visited[ -10..-1 ] if @visited.size >= 10
  @visited << @tango_id unless @visited.include?( @tango_id )
  session[ "visited" ] = @visited

  render :haml, :index
end


post '/login' do
  login    = params[ "login" ]
  password = params[ "password" ]

  User.login( login, password )

  if User.name
    flash[ :notice ] = "User logged in"
  end

  redirect '/0'
end

