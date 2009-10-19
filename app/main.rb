#
require 'rubygems'
require 'sinatra'
require 'yaml'
require 'haml'
require 'rack-flash'
require 'pony'

$:.unshift( File.dirname( __FILE__ ) )
set :public, File.join( File.dirname( __FILE__ ), "../public" )

require 'models'
Models.startup

enable :sessions
use Rack::Flash


#
before do
  Session.instance = session
  @time0 = Time.now
end

load 'controllers.rb'

get "/tango/:id" do
  @user = User.current
  @tango = Tango[ params[ :id ].to_i ]

  @title = "Tango: #{@tango.kanji}"

  @visited = Visited.ids
  Visited.store( @tango.index ) 

  @bookmarks = []

  if @user
    score = @user.score
    score.update_attributes( :tango_id => @tango.index )

    @bookmarks = @user.user_bookmarks
  end

  haml :tango
end

get "/" do
  redirect Url.user
end
