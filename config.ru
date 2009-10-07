#
set :views, File.join(File.dirname(__FILE__), 'app', 'views')

require 'app/main'
run Sinatra::Application
