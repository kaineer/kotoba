require 'rubygems'
require 'pony'
# require File.join( File.dirname( __FILE__ ), 'smtp_tls' )

def send_pony( to, subj, body )
  Pony.mail(
            :to => to,
            :from => "kaineer@gmail.com",
            :subject => subj,
            :body => body,
            :smtp =>
            {
              :address => "smtp.gmail.com",
              :port => "587",
              :domain => "kotoba.heroku.com",
              :authentication => :plain,
              :user_name => "kaineer",
              :password => 'kerahbless'
            } )
end
