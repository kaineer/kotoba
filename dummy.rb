require 'rubygems'
require 'pony'

def test_pony
  Pony.mail(:to => 'kaineer@gmail.com', :via => :smtp, :smtp => {
              :host     => 'smtp.gmail.com',
              :port     => '587',
              :tls      => true,
              :user     => 'kaineer@gmail.com',
              :password => 'kerahbless',
              :auth     => :plain, # :plain, :login, :cram_md5, no auth by default
              :domain   => "localhost.localdomain" # the HELO domain provided by the client to the server
            })
end
