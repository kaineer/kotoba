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

get "/" do
  redirect Url.user
end
