#
set :views, File.join(File.dirname(__FILE__), 'app', 'views')
# set :root, File.dirname( __FILE__ )

#
require 'app/main'
run Sinatra::Application
