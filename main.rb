#
require 'rubygems'
require 'sinatra'

require 'yaml'
require 'haml'
#

require 'rack-flash'

require 'models'
Models.startup

enable :sessions

use Rack::Flash


#
before do
  Session.instance = session
end

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

get "/tango/:id" do
  @user = User.current
  @tango = Tango[ params[ :id ].to_i ]

  @visited = Visited.ids

  @bookmarks = []

  if @user
    Visited.store( @tango.index ) 
    score = UserScore.find_or_create( User.current_id )
    score.update_attributes( :tango_id => @tango.index )

    @bookmarks = @user.user_bookmarks
  end

  haml :tango
end

get "/bookmark/:id/set" do
  @user = User.current
  @tango = Tango[ params[ :id ].to_i ]

  @user.mark( @tango.index )

  redirect Url.user
end

get "/bookmark/:id/unset" do
  @user = User.current
  @tango = Tango[ params[ :id ].to_i ]
  
  @user.unmark( @tango.index )
  
  redirect Url.user
end

get "/print" do
  @user = User.current
  @bookmarks = @user.user_bookmarks.sort_by{|b|b.tango_id}

  haml :print
end

get "/clear" do
  User.current.clear_bookmarks rescue nil
  redirect Url.user
end

get "/" do
  redirect Url.user
end
