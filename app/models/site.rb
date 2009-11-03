#
#
#

require 'yaml'

class Site
  @@config = YAML.
    load_file( File.
          join( File.dirname( __FILE__ ), 
                "../../config/site.yml" ) 
               ) rescue {}
  
  def self.base
    @@config[ 'base' ] || "http://kotoba.heroku.com"
  end

  def self.email
    @@config[ 'email' ] || "noreply@please.com"
  end
end
