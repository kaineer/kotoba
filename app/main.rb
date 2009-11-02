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
  Visited.store( @tango.index ) 

  @visited = Visited.ids

  @bookmarks = []

  if @user
    score = @user.score
    score.update_attributes( :tango_id => @tango.index )

    @bookmarks = @user.user_bookmarks

    @bookmarked = @bookmarks.find{|bkm|bkm.tango_id == @tango.index}
  end

  haml :tango
end

post "/search" do
  @user = User.current
  @bookmarks = @user.user_bookmarks

  @search_string = params[ :q ].to_s

  if @search_string.empty?
    flash[ :notice ] = "Empty search string is not allowed"
    redirect Url.user
  end

  @search_result = Tango.select_by_source( @search_string )
  if @search_result.empty?
    flash[ :notice ] = "There's nothing like `#{@search_string}'"
    redirect Url.user
  end

  haml :search
end

get "/" do
  redirect Url.user
end
