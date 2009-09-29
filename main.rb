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

load 'controllers.rb'

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

get "/bookmarks/print" do
  @user = User.current
  @bookmarks = @user.user_bookmarks.sort_by{|b|b.tango_id}

  haml :print
end

get "/bookmarks/clear" do
  User.current.clear_bookmarks rescue nil
  redirect Url.user
end

get "/" do
  redirect Url.user
end
