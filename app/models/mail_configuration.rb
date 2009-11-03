#
#
#

require 'yaml'

class MailConfiguration
  #
  def initialize
    path = File.join( File.dirname( __FILE__ ), "../../../config/site.yml" )

    if File.exist?( path )
      @config = YAML.load_file( path )

      if @config[ 'via' ] == 'sendmail'
        sendmail_config
      else
        smtp_config
      end
    else
      sendgrid_config
    end
  end

  attr_reader :via
  attr_reader :smtp

  @@config = nil
  def self.config
    @@config ||= new
    @@config
  end
  
  #
  def sendmail_config
    @via = :sendmail
    @smtp = nil
  end

  #
  def smtp_config
    @via = :smtp
    @smtp = {}
    
    @smtp[ :host ] = @config[ "host" ]
    @smtp[ :port ] = @config[ "port" ] || '25'
    @smtp[ :password ] = @config[ "password" ]
    @smtp[ :auth ] = :plain
    @smtp[ :domain ] = @config[ "domain" ]
  end

  #
  def sendgrid_config
    @via = :smtp
    @smtp = {}
    
    @smtp[ :host ]     = "smtp.sendgrid.net"
    @smtp[ :port ]     = '25'
    @smtp[ :password ] = "konaax"
    @smtp[ :auth ]     = :plain
    @smtp[ :domain ]   = "kaineer.info"
  end
end
