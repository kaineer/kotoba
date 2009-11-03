#
#
#

require 'yaml'

class Site
  @@config = nil
  def self.init
    path = File.join( File.dirname( __FILE__ ),
                      "../../config/site.yml" )
    if File.exist?( path )
      @@config = YAML.load_file( path )
    else
      @@config = {}
    end
  end

  def self.ensure_init
    init unless @@config
  end

  def self.base
    @@config[ "base" ] || "http://kotoba.heroku.com"
  end
  
  def self.email
    @@config[ "email" ] || "noreply@please.com"
  end

  def self.via
    @@config[ "via" ] || "smtp"
  end

  SENDGRID = {
    :host     => "smtp.sendgrid.net",
    :port     => "25",
    :user     => "kotoba@kaineer.info",
    :password => "failedsecret",
    :domain   => "kaineer.info"
  }

  def self.smtp
    return nil if via == "sendmail"

    @@config[ "smtp" ].inject( {} ) do |hash, ( key, value ) |
      hash[ key.to_sym ] = value
    end || SENDGRID
  end
end
