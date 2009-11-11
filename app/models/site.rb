#
#
#

require 'yaml'

class Site
  #
  def self.base
    Property[ 'site/base' ] || "http://kotoba.heroku.com"
  end
  
  def self.email
    Property[ 'pony/from' ] || "kaineer@mail.ru"
  end

  def self.via
    Property[ 'pony/via' ] || "smtp"
  end

  def self.smtp
    @smtp ||= {
      :host   => Property[ "pony/smtp/host" ],
      :port   => Property[ "pony/smtp/port" ],
      :user   => Property[ "pony/smtp/user" ],
      :password => Property[ "pony/smtp/password" ],
      :auth   => :plain,
      :domain => Property[ "pony/smtp/domain" ]
    }
  end
end
