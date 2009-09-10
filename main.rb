#
require 'rubygems'
require 'sinatra'

require 'yaml'
require 'haml'

require 'models'

enable :sessions

#
def flash
  session[ :flash ] = {} if session[ :flash ] && session[ :flash ].class != Hash
  session[ :flash ] ||= {}
end

#
def custom_render( method, *args )
  html = self.__send__( method, *args )
  flash.clear
  html
end

def tango_url( tango_id )
  "/tango/#{tango_id||0}"
end

def bookmark_url( tango_id = 0 )
  "/bookmark/#{tango_id}"
end

def print_bookmarks_url
  "/print"
end

def clear_bookmarks_url
  "/clear"
end

def user_path
  path = tango_url( 0 )
  score = UserScore.find_or_create( User.current_id )
  if score && score.tango_id
    path = tango_url( score.tango_id )
  end

  path
end

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

  redirect user_path
end

get "/logout" do
  User.logout
  Visited.clear
  flash[ :notice ] = "User logged out"
  redirect tango_url( 0 )
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

  custom_render :haml, :tango
end

get "/bookmark/:id" do
  @user = User.current
  @tango = Tango[ params[ :id ].to_i ]

  @user.mark( @tango.index )

  redirect tango_url( @tango.index )
end

get "/print" do
  @user = User.current
  @bookmarks = @user.user_bookmarks.sort_by{|b|b.tango_id}

  custom_render :haml, :print
end

get "/clear" do
  @user = User.current
  @user.clear_bookmarks
  
  redirect user_path
end

get "/" do
  redirect user_path
end
